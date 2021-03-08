require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:shop_owner) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop, user: shop_owner) }
  let!(:item1) { FactoryBot.create(:item, shop: shop) }
  let!(:item2) { FactoryBot.create(:item, shop: shop) }
  let!(:user2) { FactoryBot.create(:user, user_type: User.user_types[:delivery_person]) }
  let!(:cart_item) { FactoryBot.create(:carts_item, cart: user.cart, item: item1) }
  describe '#checkout' do
    subject do
      post :checkout, params: { payment_method: 'cod' }
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
      it 'creates an order if payment_method is cod only' do
        subject
        data = JSON.parse(response.body)['data']
        included = JSON.parse(response.body)['included']
        expect(included.size).to eq(1)
        expect(included.first['attributes']['name']).to eq(item1.name)
        expect(data['type']).to eq('order')
        expect(response.status).to eq(200)
      end
      it 'shows error message if payment method is not cod' do
        post :checkout, params: { payment_method: 'upi' }
        data = JSON.parse(response.body)
        expect(data['message']).to eq("Allowed payment methods: #{Order.payment_methods.keys.join(',')}")
        expect(response.status).to eq(422)
      end
    end

    describe '#show' do
      context 'when unauthenticated' do
        it 'returns 401' do
          get :show, params: { id: 'someid' }
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)['message']).to eq('You are not logged in')
        end
      end
      context 'when authenticated' do
        before do
          sign_in(user)
        end
        it 'should show the requested shop' do
          post :checkout, params: { payment_method: 'cod' }
          order = Order.last
          get :show, params: { id: order.order_no }
          data = JSON.parse(response.body)['data']
          expect(data['attributes']['order_no']).to eq(order.order_no)
        end
      end
    end

    describe '#index' do
      context 'when unauthenticated' do
        it 'returns 401' do
          get :index, params: {}
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)['message']).to eq('You are not logged in')
        end
      end
      context 'when authenticated' do
        it 'should list empty array if no record found' do
          sign_in(user)
          post :checkout, params: { payment_method: 'cod' }
          get :index, params: { shop_id: shop.id, from: 'deliverer' }
          data = JSON.parse(response.body)['data']
          expect(data.size).to eq(0)
        end
        it 'should return order list assigned to shop is viewed from shop owner account' do
          sign_in(user)
          post :checkout, params: { payment_method: 'cod' }
          order = Order.last
          sign_out(:user)
          sign_in(shop_owner)
          get :index, params: { shop_id: shop.id, from: 'shop' }
          data = JSON.parse(response.body)['data']
          expect(data.size).to eq(1)
          expect(data.first['attributes']['order_no']).to eq(order.order_no)
          expect(data.first['attributes']['status']).to eq('ordered')
        end
        it 'should only allow three types of apis user, shop and delivery person' do
          sign_in(user)
          get :index, params: { shop_id: shop.id, from: 'admin' }
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Bad Parameters')
          expect(response.status).to eq(400)
        end
        it 'Should not allow data if non shop owner wants to see shops orders' do
          sign_in(user)
          get :index, params: { shop_id: shop.id, from: 'shop' }
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Record not found')
          expect(response.status).to eq(404)
        end
      end
    end

    describe '#update' do
      context 'when unauthenticated' do
        it 'returns 401' do
          patch :update, params: { order_action: 'accept', id: 'someid' }
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)['message']).to eq('You are not logged in')
        end
      end
      context 'when authenticated' do
        it 'should allow order to be accepted by shop owner' do
          sign_in(user)
          post :checkout, params: { payment_method: 'cod' }
          sign_out(:user)
          sign_in(shop_owner)
          expect(Order.last.status).to eq('ordered')
          patch :update, params: { order_action: 'accept', id: Order.last.order_no }
          expect(Order.last.status).to eq('accepted')
        end
        it 'should not allow random status change' do
          sign_in(user)
          post :checkout, params: { payment_method: 'cod' }
          sign_out(:user)
          sign_in(shop_owner)
          expect(Order.last.status).to eq('ordered')
          patch :update, params: { order_action: 'picked', id: Order.last.order_no }
          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['message']).to eq('This state update is invalid')
          expect(Order.last.status).to eq('ordered')
        end
        it 'should not allow driver to update status till its picked for delivery' do
          sign_in(user)
          post :checkout, params: { payment_method: 'cod' }
          sign_out(:user)
          sign_in(user2)
          Order.last.accepted!
          patch :update, params: { order_action: 'mark_deliver', id: Order.last.order_no }
          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['message']).to eq('This state update is invalid')
          expect(Order.last.status).to eq('accepted')
        end
        it 'should not allow shop owner to mark order delivered directly' do
          sign_in(user)
          post :checkout, params: { payment_method: 'cod' }
          sign_out(:user)
          sign_in(shop_owner)
          Order.last.accepted!
          patch :update, params: { order_action: 'mark_deliver', id: Order.last.order_no }
          expect(response.status).to eq(401)
          expect(JSON.parse(response.body)['message']).to eq('This action is not allowed for current user')
          expect(Order.last.status).to eq('accepted')
        end
      end
    end
  end
end
