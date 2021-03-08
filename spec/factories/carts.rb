FactoryBot.define do
  factory :cart do
    status { 1 }
    association :user
  end
end
