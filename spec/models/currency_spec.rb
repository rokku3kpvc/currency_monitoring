require 'rails_helper'

RSpec.describe Currency, type: :model do
  let(:forced) { create(:currency_forced) }
  let(:parsed) { create(:currency_parsed) }
  let(:parsed_last) { create(:currency_parsed_last) }

  it { is_expected.to validate_presence_of(:rate) }
  it { is_expected.not_to allow_value(0).for(:rate) }
  it { is_expected.not_to allow_value(1000).for(:rate) }
  it { is_expected.to allow_value(true).for(:is_forced) }
  it { is_expected.to allow_value(false).for(:is_forced) }
  it { is_expected.to allow_value(Time.zone.now - 1.minute).for(:is_forced_by) }

  describe 'class methods' do
    describe 'with valid settings' do
      before { forced; parsed }

      context 'rates' do
        let(:forced_params) { { rate: 54.5867, is_forced: true, is_forced_by: Time.zone.now + 1.minute } }

        it 'actual_rate should return forced' do
          expect(described_class.actual_rate).to eq(forced)
        end

        it 'actual_rate should return parsed' do
          parsed_last
          expect(described_class.actual_rate).to eq(parsed_last)
        end

        it 'create_forced should create' do
          expect(described_class.create_forced(forced_params).rate).to eq(forced.rate)
        end
      end
    end

    describe 'with invalid settings' do
      let(:forced_inv_params) { { rate: 'sample text', is_forced: true, is_forced_by: Time.zone.now } }

      context 'rates' do
        it 'create_forced should not create' do
          expect(described_class.create_forced(forced_inv_params)).to_not be_valid
        end
      end
    end
  end

  describe 'instance methods' do
    describe 'with valid settings' do
      context 'when rate parsed' do
        before { parsed }

        it 'should update actual rate' do
          forced
          parsed_last
          expect(parsed_last.is_not_blocked_by_forced).to eq(true)
        end

        it 'should not update actual rate' do
          forced
          expect(parsed.is_not_blocked_by_forced).to eq(false)
        end

        it 'should return update actual rate because forced nil' do
          expect(parsed.is_not_blocked_by_forced).to eq(true)
        end
      end
    end
  end
end
