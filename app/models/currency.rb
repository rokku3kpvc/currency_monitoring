class Currency < ApplicationRecord
  scope :forced, -> { where(is_forced: true) }
  scope :parsed, -> { where(is_forced: false) }

  def self.actual_rate
    forced_last = forced.last
    parsed_last = parsed.last
    forced_last.nil? ? parsed_last : compare_rates(forced_last, parsed_last)
  end

  def self.compare_rates(forced_r, parsed_r)
    forced_r.is_forced_by > parsed_r.created_at ? forced_r : parsed_r
  end
end
