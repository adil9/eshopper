require 'rails_helper'

RSpec.describe Auth::SessionsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  describe 'POST# create session' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }
    context 'when unauthenticated' do
      subject do
        post :create, params: { user: { email: user.email, password: 'Error@haha69' } }
      end
      it 'returns nil' do
        subject
        expect(response.status).to eq(200)
      end
    end
    context 'when authenticated' do
      context 'as a user' do
        subject do
          post :create, params: { user: { email: user.email, password: 'password123' } }
        end
        it 'should redirect to eshopper home page' do
          subject
          expect(response).to redirect_to '/'
        end
      end
    end
  end

  describe 'POST# destroy session' do
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }
    context 'normal user should' do
      subject do
        sign_in(user)
        post :destroy
      end
      it 'should redirect to root sign_in path' do
        subject
        expect(response).to redirect_to '/'
      end
    end
  end
end
