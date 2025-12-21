FactoryBot.define do
  factory :booking do
    association :user, :customer
    association :trip

    status { :confirmed }
    total_amount { 1200 }

    trait :cancelled do
      status { :cancelled }
      cancelled_at { Time.current }
      cancellation_fee { 50 }
      refund_amount { 1150 }
    end
  end
end
