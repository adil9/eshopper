# Items Serialize
class ItemSerializer
  include JSONAPI::Serializer
  attributes :shop_id, :name, :description, :image_url, :category, :display_price, :discounted_price, :tax,
             :selling_stock
end
