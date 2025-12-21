FactoryBot.define do
  factory :trip do
    association :route
    association :bus
    association :operator
    travel_date { Date.tomorrow }
    departure_at { Time.now + 2.days }
    price { 1200 }
  end
end
