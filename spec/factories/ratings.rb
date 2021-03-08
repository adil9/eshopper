FactoryBot.define do
  factory :rating do
    description { 'This is a good shop' }
    rating { 4 }
    association :user
    association :shop
  end
end
