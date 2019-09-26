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
    data = ApplicationController.renderer.render(partial: 'currency/parsed', locals: { currency: job.actual_rate })
    assert_broadcast_on(RatesChannel.broadcasting_for(channel),
                        rate: data) { ParseDollarRateJob.perform_now }
  end

  it 'should stop streaming' do
    unsubscribe
    expect(subscription).not_to have_streams
  end
end