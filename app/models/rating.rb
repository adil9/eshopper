# Used to store rating for each user to shops along with text
class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  after_create :update_shop_rating
  validate :rating_value

  private

  def rating_value
    return if (1..5).include?(rating)

    errors.add :rating, :invalid, message: 'must be between 1 to 5 inclusive'
  end

  def update_shop_rating
    shop.recalculate_ratings
  end
end
