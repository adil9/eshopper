# Class for item file
class Item < ApplicationRecord
  has_many :carts_items, dependent: :restrict_with_exception
  belongs_to :shop
  has_many :orders_item, dependent: :restrict_with_exception
end
