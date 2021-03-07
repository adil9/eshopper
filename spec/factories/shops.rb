FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "shop_#{n}" }
    sequence(:description) { |n| "This is description for shop #{n}" }
    rating { 4 }
    association :user
  end
end
