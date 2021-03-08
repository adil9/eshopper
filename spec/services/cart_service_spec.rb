require 'rails_helper'

RSpec.describe CartService, type: :service do
  let!(:user) {FactoryBot.create(:user)}
  let!(:shop) { FactoryBot.create(:shop)}
  let!(:item1) {FactoryBot.create(:item, shop: shop)}
  let!(:item2) {FactoryBot.create(:item, shop: shop)}
  describe '#add_or_update!' do
    it 'will add new cart item if same item does not exist in cart' do
      carts_items_count = user.cart.carts_items.size
      CartService.new(user.cart).add_or_update!(item1.id, 10)
      expect(user.cart.reload.carts_items.size).to eq(carts_items_count+1)
    end
    it 'will update same cart item if same item exist in cart' do
      FactoryBot.create(:carts_item, cart: user.cart, item: item1)
      carts_items_count = user.cart.carts_items.size
      CartService.new(user.cart).add_or_update!(item1.id, 10)
      expect(user.cart.reload.carts_items.size).to eq(carts_items_count)
    end
    it 'will increase the quantity to 2 if same item is addded in cart' do
      FactoryBot.create(:carts_item, cart: user.cart, item: item1)
      CartService.new(user.cart).add_or_update!(item1.id, 10)
      expect(user.cart.reload.carts_items.last.quantity).to eq(12)
    end
    it 'will raise error if sellable stock is less than request' do
      expect {CartService.new(user.cart).add_or_update!(item1.id, 100)}.to raise_error CartError
    end
    it 'will raise error if sellable stock is less than request' do
      CartService.new(user.cart).add_or_update!(item1.id, 10)
      shop2 = FactoryBot.create(:shop)
      item_shop2 = FactoryBot.create(:item, shop: shop2)
      expect {CartService.new(user.cart).add_or_update!(item_shop2.id, 10)}.to raise_error CartError
    end
  end
end
