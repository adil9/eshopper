# Shop Class
class Shop < ApplicationRecord
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :items, dependent: :destroy
end
