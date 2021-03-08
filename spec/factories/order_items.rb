FactoryBot.define do
  factory :orders_item do
    quantity { 2 }
    status { 1 }
    discount { 99 }
    price { 1000 }
    tax { 18 }
    association :order
    association :item
  end
end
