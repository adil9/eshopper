require 'rails_helper'

RSpec.describe OrderService, type: :service do
  let!(:user) { FactoryBot.create(:user) }
  let!(:shop_owner) { FactoryBot.create(:user) }
  let!(:shop) { FactoryBot.create(:shop, user: shop_owner) }
  let!(:item1) { FactoryBot.create(:item, shop: shop) }
  let!(:item2) { FactoryBot.create(:item, shop: shop) }
  let!(:user2) { FactoryBot.create(:user, user_type: User.user_types[:delivery_person]) }
  let!(:cart_item) { FactoryBot.create(:carts_item, cart: user.cart, item: item1) }
  describe '#prepare_order' do
    it 'creates an order with order items' do
      order_count = Order.count
      OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect(Order.last.status).to eq('ordered')
      expect(Order.last.orders_items.size).to eq(1)
      expect(Order.count).to eq(order_count + 1)
      item1.reload
      expect(item1.selling_stock).to eq(13)
      expect(item1.total_stock).to eq(18)
    end
  end
  describe '#update_status' do
    it 'shopkeeper should be able to accept the order' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect(order.status).to eq('ordered')
      service.update_status(shop_owner.id, 'accept')
      expect(order.status).to eq('accepted')
    end
    it 'shopkeeper should be able to reject the order' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect(order.status).to eq('ordered')
      service.update_status(shop_owner.id, 'reject')
      expect(order.status).to eq('rejected')
    end
    it 'shopkeeper should be able to prepare the order' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.accepted!
      expect(order.status).to eq('accepted')
      service.update_status(shop_owner.id, 'make_ready')
      expect(order.status).to eq('ready_for_delivery')
    end
    it 'shopkeeper should be able to give it to deliverer for delivery' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.ready_for_delivery!
      expect(order.status).to eq('ready_for_delivery')
      service.update_status(shop_owner.id, 'picked')
      expect(order.status).to eq('out_for_delivery')
    end
    it 'shopkeeper should not be able to mark as delivered' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.out_for_delivery!
      expect(order.status).to eq('out_for_delivery')
      expect { service.update_status(shop_owner.id, 'delivered') }.to raise_error NotAllowedError
    end
    it 'shopkeeper should not be able to randomly update status' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.out_for_delivery!
      expect(order.status).to eq('out_for_delivery')
      expect { service.update_status(shop_owner.id, 'delivered') }.to raise_error NotAllowedError
      order.ordered!
      expect { service.update_status(shop_owner.id, 'make_ready') }.to raise_error AASM::InvalidTransition
      order.ready_for_delivery!
      expect { service.update_status(shop_owner.id, 'accept') }.to raise_error AASM::InvalidTransition
    end
    # Delivery Person related changes
    it 'deliverer should only be able to mark as delivered' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.delivery_person_id = user2.id
      order.out_for_delivery!
      expect(order.status).to eq('out_for_delivery')
      service.update_status(user2.id, 'mark_deliver')
      expect(order.status).to eq('delivered')
    end
    it 'deliverer should not be able to randomly update status' do
      service = OrderService.new
      order = service.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.delivery_person_id = user2.id
      order.save
      expect(order.status).to eq('ordered')
      expect { service.update_status(user2.id, 'delivered') }.to raise_error NotAllowedError
      order.delivered!
      expect { service.update_status(user2.id, 'picked') }.to raise_error NotAllowedError
      order.ready_for_delivery!
      expect { service.update_status(user2.id, 'accepted') }.to raise_error NotAllowedError
    end
  end
  describe '#shop_orders' do
    it 'lists shop owners orders based on shop id' do
      service = OrderService.new
      OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect(service.shop_orders(shop_owner, { shop_id: shop.id }).size).to eq(1)
    end
    it 'lists shop owners orders with shop id as filter' do
      service = OrderService.new
      OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect { service.shop_orders(shop_owner, { shop_id: 3333 }) }.to raise_error ActiveRecord::RecordNotFound
    end
    it 'Only shop owner can access this method' do
      service = OrderService.new
      OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect { service.shop_orders(user, { shop_id: shop.id }) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
  describe '#user_orders' do
    it 'lists passed users orders as a consumer' do
      service = OrderService.new
      OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect(service.user_orders(user, {}).size).to eq(1)
    end
    it 'should only return me my orders' do
      service = OrderService.new
      OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      expect(service.user_orders(user2, {}).size).to eq(0)
    end
  end
  describe '#deliverer_orders' do
    it 'this returns currently active and assigned order for deliverer' do
      service = OrderService.new
      order = OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.delivery_person_id = user2.id
      order.save
      expect(service.deliverer_orders(user2, {}).size).to eq(1)
    end
    it 'should not be able to access shop orders' do
      service = OrderService.new
      order = OrderService.new.prepare_order(user.id, Order.payment_methods[:cod], user.cart.reload)
      order.delivery_person_id = user2.id
      order.save
      expect { service.shop_orders(user2, {}) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
