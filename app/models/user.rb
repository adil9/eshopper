# Class for User
class User < ApplicationRecord
  acts_as_mappable default_units: :kms
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :shops, dependent: :destroy
  has_many :ratings, dependent: :nullify
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  after_create :create_cart!

  enum user_type: { user: 1, delivery_person: 2, admin: 3 }
  enum status: { available: 1, occupied: 2 }
  validates :email, presence: true, uniqueness: true, case_sensitive: false
  validates :phone, presence: true, uniqueness: true, case_sensitive: false
  validates :first_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
