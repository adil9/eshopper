require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe '#associations' do
    it { should respond_to(:user) }
    it { should respond_to(:carts_items) }
    it { should respond_to(:items) }
    it { should respond_to(:all_carts_items) }
    it { should respond_to(:total_price) }
    it { should respond_to(:total_discount) }
    it { should respond_to(:active?) }
    it { should respond_to(:checkout?) }
    it { should respond_to(:ideal?) }
  end
end
