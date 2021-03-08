require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) {FactoryBot.create(:user)}
  let!(:user2) {FactoryBot.create(:user, user_type: User.user_types[:delivery_person])}
  let!(:shop) { FactoryBot.create(:shop)}
  let!(:item) {FactoryBot.create(:item, shop: shop)}
  let!(:order) {FactoryBot.create(:order, delivery_person_id: user2.id, user: user)}
  let!(:cart_item) {FactoryBot.create(:carts_item, cart: user.cart, item: item)}
  let!(:order_item) {FactoryBot.create(:orders_item, item: item, order: order)}
  describe '#associations and statuses and methods' do
    it { should respond_to(:user) }
    it { should respond_to(:shop) }
    it { should respond_to(:orders_items) }
    it { should respond_to(:items) }
    it { should respond_to(:invoice) }
    it { should respond_to(:created?) }
    it { should respond_to(:ordered?) }
    it { should respond_to(:accepted?) }
    it { should respond_to(:rejected?) }
    it { should respond_to(:ready_for_delivery?) }
    it { should respond_to(:out_for_delivery?) }
    it { should respond_to(:delivered?) }
  end
  describe '#events' do
    it {should respond_to(:reject)}
    it {should respond_to(:accept)}
    it {should respond_to(:make_ready)}
    it {should respond_to(:picked)}
    it {should respond_to(:mark_deliver)}
  end

  describe '#assign_deliverer' do
    it 'should assign a nearby delivery boy to order' do
      expect(user2.available?).to be_truthy
      order.send(:assign_deliverer)
      expect(user2.reload.occupied?).to be_truthy
    end
  end
  describe '#free_deliverer' do
    it 'should free the deliverer for other orders once order is delivered' do
      user2.occupied!
      expect(user2.available?).to be_falsey
      order.send(:free_deliverer)
      expect(user2.reload.available?).to be_truthy
    end
  end
  describe '#clear_cart' do
    it 'Update the status of cart items as ordered so that the active cart can be cleared' do
      expect(user.cart.carts_items.size).to eq(1)
      order.send(:clear_cart)
      cart = user.cart.reload
      expect(cart.carts_items.size).to eq(0)
      expect(cart.all_carts_items.size).to eq(1)
    end
  end
end
