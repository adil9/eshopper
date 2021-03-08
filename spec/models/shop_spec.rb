require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe '#associations' do
    it { should respond_to(:user) }
    it { should respond_to(:ratings) }
    it { should respond_to(:items) }
    it { should respond_to(:orders) }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:lat) }
    it { is_expected.to validate_presence_of(:lng) }
  end
end
