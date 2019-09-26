class Currency < ApplicationRecord
  validates :rate, presence: true, numericality: { only_float: true, greater_than: 0.0, less_than_or_equal_to: 999.9999 }
  validates :is_forced_by, date: { allow_blank: true }
  validate :forced_time_valid

  scope :forced, -> { where(is_forced: true) }
  scope :parsed, -> { where(is_forced: false) }

  def self.actual_rate
    forced_last = forced.last
    parsed_last = parsed.last
    forced_last.nil? ? parsed_last : compare_rates(forced_last, parsed_last)
  end

  def self.compare_rates(forced_r, parsed_r)
    return forced_r if parsed_r.nil?

    forced_r.is_forced_by > parsed_r.created_at ? forced_r : parsed_r
  end

  def self.create_forced(params)
    forced_currency = Currency.new params
    forced_currency.save ? forced_currency.update_rates : forced_currency
  end

  def update_rates
    data = ApplicationController.renderer.render(partial: 'currency/forced', locals: { currency: self })
    ActionCable.server.broadcast "rates_channel", rate: data
    ParseDollarRateJob.set(wait_until: is_forced_by).perform_later
    self
  end

  def is_not_blocked_by_forced
    forced_last = Currency.forced.last
    return true if forced_last.nil?

    created_at >= forced_last.is_forced_by
  end

  private

  def forced_time_valid
    if is_forced?
      errors.add(:is_forced_by, "can't be empty") if is_forced_by.nil?
      errors.add(:is_forced_by, "must be later than the current time is") if (
        !is_forced_by.nil? && (is_forced_by < Time.zone.now.utc)
      )
    end
  end
end
