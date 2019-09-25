require 'open-uri'

class ParseDollarRateJob < ApplicationJob
  queue_as :default
  attr_accessor :cbr, :usd_xpath, :usd_rate

  def perform(*args)
    initialize_vars
    parse_usd_rate
  end

  private

  def initialize_vars
    @cbr = 'https://www.cbr.ru/currency_base/daily/'
    @usd_xpath = '//*[@id="content"]/table/tbody/tr[12]/td[5]'
  end

  def parse_usd_rate
    cbr_page = open(@cbr)
    document = Nokogiri::HTML(cbr_page)
    @usd_rate = document.xpath(@usd_xpath)
    puts @usd_rate.text
  end
end
