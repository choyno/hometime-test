FactoryBot.define do
  factory :guest do
    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:first_name) { |n| "#{Faker::Name.name}#{n}" }
    sequence(:last_name) { |n| "Parker#{n}" }
    phone_numnbers  { Faker::PhoneNumber.phone_number.phony_formatted(spaces: '') }
  end
end
