# Holds order of user
class Order < ApplicationRecord
  # We need to keep versioning these tables too
  belongs_to :user
  belongs_to :shop
  has_many :orders_items, dependent: :destroy
  has_many :items, through: :orders_items
  has_one :invoice, dependent: :destroy
  before_save :assign_deliverer, if: -> { status_changed? && accepted? }
  before_create :set_order_no
  after_save :free_deliverer, if: -> { saved_change_to_status? && delivered? }
  after_save :initiate_refund, if: -> { saved_change_to_status? && rejected? }
  after_save :clear_cart, if: -> { saved_change_to_status? && ordered? }
  include AASM
  aasm column: :status, enum: true do
    state :created, initial: true
    state :ordered
    state :accepted
    state :rejected
    state :ready_for_delivery
    state :out_for_delivery
    state :delivered

    event :cancel do
      transitions from: :created, to: :cancelled
    end

    event :order do
      transitions from: :created, to: :ordered
    end

    event :decline do
      transitions from: :created, to: :declined
    end

    event :reject do
      transitions from: :ordered, to: :rejected
    end

    event :accept do
      transitions from: :ordered, to: :accepted
    end

    event :make_ready do
      transitions from: :accepted, to: :ready_for_delivery
    end

    event :picked do
      transitions from: :ready_for_delivery, to: :out_for_delivery
    end

    event :mark_deliver do
      transitions from: :out_for_delivery, to: :delivered
    end
  end
  # before_save :generate_invoice, if: -> {saved_change_to_status? and ordered!}
  enum status: {
    created: 1, cancelled: 2, rejected: 3, ordered: 4, accepted: 5, ready_for_delivery: 6, out_for_delivery: 7,
    delivered: 8, declined: 9
  }

  enum payment_method: { cod: 1, upi: 2 }

  private

  def assign_deliverer
    deliverer = User.available.delivery_person.within(CONFIG[:deliverer_search_radius], origin: [shop.lat, shop.lng])
                    .first
    # This below action can fail when no user is available withing search distance.
    # We can use multiple strategy to counter it.
    #   1. Increase radius and try again
    #   2. Keep retrying
    #   3. Drop a notification to shop that no delivery guy is available yet and may be arrange some possible way
    # TODO remove & and add strategies to counter this case.
    deliverer&.occupied!
    self.delivery_person_id = deliverer.id
  end

  def free_deliverer
    deliverer = User.find(delivery_person_id)
    deliverer.available!
  end

  def clear_cart
    cart = user.cart
    cart.ideal!
    cart.carts_items.each(&:ordered!)
  end

  def initiate_refund
    # Initiate refund
  end

  def set_order_no
    self.order_no = SecureRandom.uuid
  end
end
