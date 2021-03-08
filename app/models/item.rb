# Class for item file
class Item < ApplicationRecord
  paginates_per 50
  enum category: { document: 1, grocery: 2, electronic: 3, cloth: 4, household: 5 }
  has_many :carts_items, dependent: :restrict_with_exception
  belongs_to :shop
  has_many :orders_item, dependent: :restrict_with_exception
end
