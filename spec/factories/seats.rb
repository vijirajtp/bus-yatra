FactoryBot.define do
  factory :seat do
    association :bus
    sequence(:seat_number) { |n| "A#{n}" }
    seat_row { 1 }
    seat_column { 1 }
  end
end