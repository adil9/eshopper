require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#associations' do
    it { should respond_to(:shops) }
    it { should respond_to(:orders) }
    it { should respond_to(:ratings) }
    it { should respond_to(:cart) }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_uniqueness_of(:phone) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe '#full_name' do
    it 'should return firstname+lastname' do
      user = FactoryBot.create(:user, first_name: 'adil', last_name: 'ansar')
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end
