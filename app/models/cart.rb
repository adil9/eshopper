# Holds information about cart
class Cart < ApplicationRecord
  belongs_to :user
  has_many :carts_items, dependent: :destroy
end
