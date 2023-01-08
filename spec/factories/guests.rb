FactoryBot.define do
  factory :guest do
    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:first_name) { |n| "#{Faker::Name.name}#{n}" }
    sequence(:last_name) { |n| "Parker#{n}" }
    phone_numbers { [Faker::Number.decimal_part(digits: 11)] }
  end
end
