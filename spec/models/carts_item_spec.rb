require 'rails_helper'

RSpec.describe CartsItem, type: :model do
  describe '#associations' do
    it { should respond_to(:item) }
    it { should respond_to(:cart) }
    it { should respond_to(:update_cart_status) }
    it { should respond_to(:active?) }
    it { should respond_to(:checkout?) }
    it { should respond_to(:removed?) }
    it { should respond_to(:ordered?) }
  end

  describe '#update_cart_status' do
    it 'should activate the cart as soon as a cart item is created freshly' do
      user = FactoryBot.create(:user)
      shop = FactoryBot.create(:shop)
      item = FactoryBot.create(:item, shop: shop)
      cart = user.cart
      cart_item = FactoryBot.create(:carts_item, cart: cart, item: item)
      cart.ideal!
      cart_item.update!(cart_id: cart.id)
      expect(cart.active?).to be_falsey
    end
  end
end
