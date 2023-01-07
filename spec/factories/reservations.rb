FactoryBot.define do
  factory :reservation do
    guest { create(:guest) }
    sequence(:reservation_code) { |n| "YYY123456#{n}" }
    start_date { Time.zone.now }
    end_date { Time.zone.now + 2.day }
    nights { Faker::Number.digit }
    guests { Faker::Number.digit }
    adults { Faker::Number.digit }
    children { Faker::Number.digit }
    infants { Faker::Number.digit }
    status { "accepted" }
    localized_description { " this ia sample guest request"}
    currency { Faker::Number.decimal(l_digits: 3, r_digits: 3) }
    payout_price { Faker::Number.decimal(l_digits: 3, r_digits: 3)}
    security_price { Faker::Number.decimal(l_digits: 3, r_digits: 3)}
    total_price { Faker::Number.decimal(l_digits: 3, r_digits: 3) }
  end
end
