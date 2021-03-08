require 'rails_helper'

RSpec.describe Api::V1::CartsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop) }
  let!(:shop2) { FactoryBot.create(:shop) }
  let!(:item_shop1) { FactoryBot.create(:item, shop: shop) }
  let!(:item_shop2) { FactoryBot.create(:item, shop: shop) }
  let!(:item_shop3) { FactoryBot.create(:item, shop: shop) }
  let!(:item_shop4) { FactoryBot.create(:item, shop: shop2) }
  describe '#update_item' do
    subject do
      post :update_item, params: { item_id: item_shop1.id, item_quantity: 2 }
    end
    context 'when unauthenticated' do
      it 'returns 401' do
        subject
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['message']).to eq('You are not logged in')
      end
    end
    context 'when authenticated' do
      before do
        sign_in(user)
      end
      it 'updates existing item if same item is added again' do
        subject
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)['data']
        included = JSON.parse(response.body)['included']
        expect(data['type']).to eq('cart')
        expect(included.size).to eq(1)
        expect(included.first['attributes']['quantity']).to eq(2)
        subject
        data = JSON.parse(response.body)['data']
        included = JSON.parse(response.body)['included']
        expect(response.status).to eq(200)
        expect(data['type']).to eq('cart')
        expect(included.size).to eq(1)
        expect(included.first['attributes']['quantity']).to eq(2)
      end
      it 'adds new item if item is not in cart' do
        subject
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)['data']
        included = JSON.parse(response.body)['included']
        expect(data['type']).to eq('cart')
        expect(included.size).to eq(1)
        expect(included.first['attributes']['quantity']).to eq(2)
      end
      it 'returns error if item quantity exceeds the stock' do
        post :update_item, params: { item_id: item_shop1.id, item_quantity: item_shop1.selling_stock + 1 }
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['message']).to eq('Stock not available, try reducing quantity if more than 1 selected')
      end
      it 'returns error if cart is not empty and item from different shop is added' do
        FactoryBot.create(:carts_item, cart: user.cart, item: item_shop1)
        post :update_item, params: { item_id: item_shop4.id, item_quantity: 2 }
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['message']).to eq('Adding items to cart from different shops not allowed')
      end
    end

    describe '#list_item' do
      subject do
        post :list_item, params: {}
      end
      context 'when unauthenticated' do
        it 'returns 401' do
          subject
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)['message']).to eq('You are not logged in')
        end
      end
      context 'when authenticated' do
        before do
          sign_in(user)
        end
        it 'should show added data in cart' do
          post :update_item, params: { item_id: item_shop1.id, item_quantity: 2 }
          subject
          data = JSON.parse(response.body)['data']
          included = JSON.parse(response.body)['included']
          expect(data['type']).to eq('cart')
          expect(included.size).to eq(1)
          expect(included.first['attributes']['quantity']).to eq(2)
          expect(included.first['attributes']['name']).to eq(item_shop1.name)
        end
      end
    end
  end
end
