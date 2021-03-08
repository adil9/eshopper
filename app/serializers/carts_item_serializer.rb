# Serializer for cart item
class CartsItemSerializer
  include JSONAPI::Serializer
  attributes :quantity, :discount, :price, :tax, :status
  attribute :name do |obj|
    obj.item.name
  end
  attribute :description do |obj|
    obj.item.description
  end
  attribute :image_url do |obj|
    obj.item.image_url
  end
end
