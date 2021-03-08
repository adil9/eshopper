require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  describe 'GET logged_in_user' do
    subject do
      get :logged_in_user, params: {}
    end
    context 'when unauthenticated' do
      it 'returns nil' do
        subject
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)['data']).to eq nil
      end
    end
    context 'when authenticated' do
      before do
        sign_in(user)
      end
      it 'returns user json' do
        subject
        expect(response.status).to eq 200
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id']).to eq user.id.to_s
        expect(json_response['data']['type']).to eq 'user'
        expect(json_response['data']['attributes']['email']).to eq user.email
        expect(json_response['data']['attributes']['phone']).to eq user.phone
        expect(json_response['data']['attributes']['full_name']).to eq user.full_name
      end
    end
  end
  describe '#update_location' do
    subject do
      post :update_location, params: { lat: 28.25, lng: 77.90 }
    end
    context 'when unauthenticated' do
      it 'returns nil' do
        subject
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)['data']).to eq nil
      end
    end
    context 'when authenticated' do
      before do
        sign_in(user)
      end
      it 'returns user json' do
        subject
        expect(user.lat.to_s).not_to eq(28.25.to_s)
        expect(user.lng.to_s).not_to eq(77.90.to_s)
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq({})
        user.reload
        expect(user.lat.to_s).to eq(28.25.to_s)
        expect(user.lng.to_s).to eq(77.90.to_s)
      end
    end
  end
end
