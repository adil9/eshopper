# Used to store rating for each user to shops along with text
class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :shop
end
