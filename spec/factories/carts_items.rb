FactoryBot.define do
  factory :carts_item do
    quantity { 2 }
    status { 1 }
    discount { 99 }
    price { 1000 }
    tax { 18 }
    association :cart
  end
end
