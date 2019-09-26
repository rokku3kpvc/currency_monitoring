require 'rails_helper'

RSpec.describe RatesChannel, type: :channel do
  let(:job) { ParseDollarRateJob.new }
  let(:channel) { "rates_channel" }

  before do
    stub_connection
    subscribe
  end

  it "should accept subscription" do
    expect(subscription).to be_confirmed
    expect(streams).to include(channel)
  end

  it 'should broadcast new_rate data' do
    job.instance_eval { perform }
    assert_broadcast_on(RatesChannel.broadcasting_for(channel),
                        rate: job.actual_rate.rate) { ParseDollarRateJob.perform_now }
  end

  it 'should stop streaming' do
    unsubscribe
    expect(subscription).not_to have_streams
  end
end