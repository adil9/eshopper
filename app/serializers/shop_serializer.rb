class ShopSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :lat, :lng, :image_url, :rating
end
