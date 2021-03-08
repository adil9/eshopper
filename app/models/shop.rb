# Shop Class
class Shop < ApplicationRecord
  acts_as_mappable default_units: :kms
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :orders, dependent: :nullify
  validates :name, presence: true
  validates :lat, presence: true
  validates :lng, presence: true

  def recalculate_ratings
    user_reviews = ratings.pluck(:rating)
    update!(rating: format('%.2f', (user_reviews.sum / user_reviews.size)).to_f)
  end
end
