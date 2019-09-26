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
  end
end
