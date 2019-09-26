require 'rails_helper'

module AuthHelper
  def http_login
    user = 'admin'
    pw = 'admin'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
end

RSpec.describe CurrencyController, type: :controller do
  include AuthHelper
  let(:new_currency) { Currency.new(is_forced: true) }
  let(:valid_attr) { { currency: { is_forced: true, is_forced_by: Time.zone.now + 1.minute, rate: 53.47584 } } }

  describe 'with empty db' do
    context 'GET index' do
      it 'should assign nil @currency' do
        get :index
        expect(assigns(:currency)).to eq(nil)
        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end
    end

    context 'GET new' do
      context 'unauthorized' do
        it 'should complete with 401' do
          get :new
          expect(response).to have_http_status(401)
        end
      end

      context 'with authorization' do
        it 'should assign nil @previous_currency' do
          http_login
          get :new
          expect(response).to have_http_status(200)
          expect(response).to render_template(:new)
          expect(assigns(:currency).attributes).to eq(new_currency.attributes)
          expect(assigns(:previous_currency)).to eq(nil)
        end
      end
    end

    context 'POST create' do
      context 'unauthorized' do
        it 'should complete with 401' do
          post :create
          expect(response).to have_http_status(401)
        end
      end

      context 'with authorization' do
        before { http_login }
        let(:invalid_attr) { { currency: { is_forced: true, is_forced_by: Time.zone.now - 1.minute, rate: 'sample' } } }

        it 'should create forced and assigned it' do
          post :create, params: valid_attr
          expect(response).to redirect_to action: :index
          expect(assigns(:currency).attributes[:rate]).to eq(valid_attr['rate'])
        end

        it 'should return to the form with error' do
          post :create, params: invalid_attr
          expect(response).to have_http_status(400)
          expect(response).to render_template(:new)
          expect(flash[:alert]).to match(/Rate is not a number and Is forced by is invalid/)
        end
      end
    end
  end

  describe 'with filled db' do
    let(:forced) { create(:currency_forced) }
    let(:parsed) { create(:currency_parsed) }
    let(:parsed_last) { create(:currency_parsed_last) }

    before { forced; parsed }

    context 'GET index' do

      it 'should assign forced @currency' do
        get :index
        expect(assigns(:currency)).to eq(forced)
        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end

      it 'should assign parsed @currency' do
        parsed_last
        get :index
        expect(assigns(:currency)).to eq(parsed_last)
        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end
    end

    context 'GET new' do
      it 'should assign forced @previous_currency' do
        http_login
        get :new
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
        expect(assigns(:currency).attributes).to eq(new_currency.attributes)
        expect(assigns(:previous_currency)).to eq(forced)
      end
    end

    context 'POST create' do
      let(:actual_rate) { Currency.actual_rate }

      it 'should set the new actual_rate' do
        http_login
        post :create, params: valid_attr
        expect(response).to redirect_to action: :index
        expect(assigns(:currency)).to eq(actual_rate)
      end
    end
  end
end
