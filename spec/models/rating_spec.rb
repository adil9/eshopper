require 'rails_helper'

RSpec.describe Rating, type: :model do
  let!(:user) {FactoryBot.create(:user)}
  let!(:shop) { FactoryBot.create(:shop, rating: 0)}

  describe '#associations and statuses and methods' do
    it { should respond_to(:user) }
    it { should respond_to(:shop) }
  end

  describe '#update_shop_rating' do
    it 'updates shop rating whenever a user reviews the shop' do
      expect(shop.rating).to eq(0)
      rating = FactoryBot.create(:rating, user: user, shop: shop)
      rating.send(:update_shop_rating)
      expect(shop.rating).to eq(4)
      rating = FactoryBot.create(:rating, user: user, shop: shop, rating: 5)
      rating.send(:update_shop_rating)
      expect(shop.rating).to eq(4.5)
    end
  end
  describe '#rating_value' do
    it 'Do not allow update if rating is not withing permissible range (1-5)' do
      expect {FactoryBot.create(:rating, user: user, shop: shop, rating: 6) }
          .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
