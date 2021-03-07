# Holds items info when they were loaded in the cart
class CartsItem < ApplicationRecord
  belongs_to :item
  belongs_to :cart
end
