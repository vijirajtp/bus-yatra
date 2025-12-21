FactoryBot.define do
  factory :seat_hold do
    association :user, :customer
    association :trip

    expires_at { 5.minutes.from_now }

    trait :expired do
      expires_at { 10.minutes.ago }
    end
  end
end