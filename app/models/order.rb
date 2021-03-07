# Holds order of user
class Order < ApplicationRecord
  belongs_to :user
  has_many :orders_items, dependent: :destroy
  has_many :items, through: :orders_items
end
