# Class for User
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :shops, dependent: :destroy
  has_many :ratings, dependent: :nullify
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy

  enum user_type: { user: 1, deliver_person: 2, admin: 3 }
  validates :email, presence: true, uniqueness: true, case_sensitive: false
  validates :phone, presence: true, uniqueness: true, case_sensitive: false
  validates :first_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
