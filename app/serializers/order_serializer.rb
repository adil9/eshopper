class OrderSerializer
  include JSONAPI::Serializer
  attributes :order_no, :status, :payment_method
  has_many :orders_items, serializer: CartsItemSerializer, key: :orders_items, record_type: :orders_item
end
