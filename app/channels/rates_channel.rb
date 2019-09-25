class RatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "rates_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
