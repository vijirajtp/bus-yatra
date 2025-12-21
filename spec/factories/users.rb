FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    confirmed_at { Time.current }

    trait :admin do
      role { :admin }
    end

    trait :operator do
      role { :operator }
    end

    trait :customer do
      role { :customer }
    end
  end
end