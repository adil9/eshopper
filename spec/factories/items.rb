FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "item_#{n}" }
    sequence(:description) { |n| "This is description for item #{n}" }
    category { rand(1..5) }
    display_price { 349 }
    discounted_price { 299 }
    tax { 18 }
    selling_stock { 15 }
    total_stock { 20 }
  end
end
