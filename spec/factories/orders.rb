FactoryBot.define do
  factory :order do
    order_no { SecureRandom.uuid }
    status { 1 }
    association :user
    association :shop
  end
end
