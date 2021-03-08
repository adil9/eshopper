# Serializer for cart
class CartSerializer
  include JSONAPI::Serializer

  attributes :total_price, :total_discount
  attribute :name do |_obj|
    'Cart'
  end
  has_many :carts_items
end
