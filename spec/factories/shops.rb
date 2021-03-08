FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "shop_#{n}" }
    sequence(:description) { |n| "This is description for shop #{n}" }
    lat { 28.631024 }
    lng { 77.219788 }
    rating { 0 }
    association :user
  end
end
