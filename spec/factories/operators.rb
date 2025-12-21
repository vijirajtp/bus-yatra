FactoryBot.define do
  factory :operator do
    association :user
    name { Faker::Company.name }
  end
end