# Holds information about cart
class Cart < ApplicationRecord
  belongs_to :user
  has_many :carts_items, -> { active }, dependent: :destroy, inverse_of: :cart
  has_many :all_carts_items, class_name: 'CartsItem', dependent: :destroy
  has_many :items, through: :carts_items
  enum status: { active: 1, checkout: 2, ideal: 3 }

  def total_price
    (carts_items.map { |item| item.price * item.quantity }).sum
  end

  def total_discount
    (carts_items.map { |item| item.discount * item.quantity }).sum
  end
end
