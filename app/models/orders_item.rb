# Holds items info when order was placed
class OrdersItem < ApplicationRecord
  belongs_to :item
  belongs_to :order
end
