require 'open-uri'

class ParseDollarRateJob < ApplicationJob
  queue_as :default
  attr_accessor :cbr, :usd_xpath, :usd_rate, :actual_rate

  def perform(*args)
    initialize_vars
    parse_usd_rate
    update_rate
    broadcast_rate if @actual_rate.save! && @actual_rate.is_not_blocked_by_forced
  end

  private

  def initialize_vars
    @cbr = 'https://www.cbr.ru/currency_base/daily/'
    @usd_xpath = '//*[@id="content"]/table/tbody/tr[12]/td[5]'
  end

  def parse_usd_rate
    cbr_page = open(@cbr)
    document = Nokogiri::HTML(cbr_page)
    rate = document.xpath(@usd_xpath).text
    @usd_rate = rate.gsub!(',', '.').to_f
  end

  def update_rate
    @actual_rate = Currency.new(rate: @usd_rate)
  end

  def broadcast_rate
    broadcast_data = ApplicationController.renderer.render(partial: 'currency/parsed', locals: { currency: @actual_rate })
    ActionCable.server.broadcast "rates_channel", rate: broadcast_data
  end
end
