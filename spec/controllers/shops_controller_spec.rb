require 'rails_helper'

RSpec.describe Api::V1::ShopsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop) }
  let!(:shop_far) { FactoryBot.create(:shop, lat: 29.630676, lng: 77.324571) }
  describe '#index' do
    subject do
      get :index, params: {}
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
      it 'returns list of shops within prescribed range' do
        subject
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(1)
      end
      it 'returns updated list of shops if new shop opens within radius' do
        FactoryBot.create(:shop, lat: 28.635224, lng: 77.246288)
        subject
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(2)
      end
      it 'shows error message if user location is not set' do
        user.update(lat: nil, lng: nil)
        subject
        data = JSON.parse(response.body)
        expect(data['message']).to eq('User address not set')
        expect(response.status).to eq(422)
      end
    end

    describe '#show' do
      subject do
        get :show, params: { id: shop.id }
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
        it 'should show the requested shop' do
          subject
          data = JSON.parse(response.body)['data']
          expect(data['id']).to eq(shop.id.to_s)
        end
      end
    end

    describe '#rate' do
      subject do
        post :rate, params: { id: shop, rating: 4 }
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
        it 'should show not be able to rate if have not ordered from the shop' do
          subject
          data = JSON.parse(response.body)
          expect(data['message']).to eq('You cannot rate a shop without ordering')
          expect(response.status).to eq(401)
        end
        it 'should be able to rate once ordered from the shop' do
          FactoryBot.create(:order, user: user, shop: shop)
          subject
          data = JSON.parse(response.body)
          expect(data['message']).to eq('success')
          expect(response.status).to eq(200)
        end
        it 'should not be able to input a value which is greater than 5' do
          FactoryBot.create(:order, user: user, shop: shop)
          post :rate, params: { id: shop, rating: 6 }
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Validation failed: Rating must be between 1 to 5 inclusive')
          expect(response.status).to eq(422)
        end
        it 'should not be able to input a value which is less than 1' do
          FactoryBot.create(:order, user: user, shop: shop)
          post :rate, params: { id: shop, rating: 0 }
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Validation failed: Rating must be between 1 to 5 inclusive')
          expect(response.status).to eq(422)
        end
        it 'shops rating should change once someone rates it' do
          FactoryBot.create(:order, user: user, shop: shop)
          expect(shop.rating).to eq(0)
          subject
          data = JSON.parse(response.body)
          expect(data['message']).to eq('success')
          expect(response.status).to eq(200)
          shop.reload
          expect(shop.rating).to eq(4)
          user2 = FactoryBot.create(:user)
          sign_out(:user)
          sign_in(user2)
          FactoryBot.create(:order, user: user2, shop: shop)
          post :rate, params: { id: shop, rating: 3 }
          shop.reload
          expect(shop.rating).to eq(3.5)
        end
      end
    end
  end
end
