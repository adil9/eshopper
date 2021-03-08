# Holds items info when they were loaded in the cart
class CartsItem < ApplicationRecord
  belongs_to :item
  belongs_to :cart, inverse_of: :carts_items
  after_create :update_cart_status, unless: -> { cart.active? }
  enum status: { active: 1, checkout: 2, removed: 3, ordered: 4 }

  def update_cart_status
    cart.active!
  end
end
