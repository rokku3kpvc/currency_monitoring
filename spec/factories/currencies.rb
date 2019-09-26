FactoryBot.define do
  factory :currency do
    factory :currency_forced do
      rate { 54.5867 }
      is_forced { true }
      is_forced_by { Time.zone.now + 1.minute }
    end

    factory :currency_parsed do
      rate { 47.5945 }
      created_at { Time.zone.now }
    end

    factory :currency_parsed_last do
      rate { 75.6857 }
      created_at { Time.zone.now + 2.minutes }
    end

    factory :currency_forced_invalid do
      rate { 'sample_text' }
    end
  end
end