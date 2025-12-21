FactoryBot.define do
  factory :bus do
    association :operator
    name { "Volvo" }
    bus_type { :ac_sleeper }
  end
end
