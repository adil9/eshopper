require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop) }
  let!(:shop2) { FactoryBot.create(:shop) }
  let!(:item_shop1) { FactoryBot.create(:item, shop: shop, category: 'grocery') }
  let!(:item_shop2) { FactoryBot.create(:item, shop: shop, category: 'grocery') }
  let!(:item_shop3) { FactoryBot.create(:item, shop: shop, category: 'document') }
  let!(:item_shop4) { FactoryBot.create(:item, shop: shop2, category: 'grocery') }
  describe '#index' do
    subject do
      get :index, params: { shop_id: shop.id, category: 'grocery' }
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
      it 'returns list of items based on params passed' do
        subject
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(2)
      end
      it 'empty array if no matching criteria met' do
        get :index, params: { shop_id: shop.id, category: 'random_category' }
        data = JSON.parse(response.body)['data']
        expect(data.size).to eq(0)
        expect(response.status).to eq(200)
      end
    end

    describe '#show' do
      subject do
        get :show, params: { id: item_shop2.id }
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
        it 'should show the requested item' do
          subject
          data = JSON.parse(response.body)['data']
          expect(data['id']).to eq(item_shop2.id.to_s)
        end
      end
    end
  end
end
