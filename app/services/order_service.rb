# Prepares order and does management
class OrderService
  def initialize(order = nil)
    @order = order
  end

  def prepare_order(current_user_id, payment_method, cart)
    carts_items = cart.carts_items
    cart.checkout!
    begin
      @order = Order.create!(
        shop_id: carts_items.first.item.shop_id,
        user_id: current_user_id,
        payment_method: payment_method
      )
    rescue StandardError
      raise NotAllowedError, "Allowed payment methods: #{Order.payment_methods.keys.join(',')}"
    end
    carts_items.each do |item|
      main_item = item.item
      OrdersItem.create!(
        quantity: item.quantity, price: item.price, discount: item.discount, tax: item.tax, item_id: main_item.id,
        order_id: @order.id
      )
      main_item.selling_stock = main_item.selling_stock - item.quantity
      main_item.total_stock = main_item.total_stock - item.quantity
      main_item.save!
    end
    # It will be in this flow only where we need to take care of multiple people eyeing on single quantity item in
    # their respective carts.
    # Payment flow can start from here using payment service
    # Which will first create a payment instruction to suggest what all needs to be deducted and how
    # Then that instruction will be executed using payment execution engine (a separate service)
    # Once the PG response is success, order status is marked as `ordered`.
    # Initiate the payment flow and once payment is completed re update the order status
    @order.ordered!
    @order
  end

  def update_status(current_user_id, action)
    # TODO: pundit
    raise NotAllowedError, 'This action is not allowed for current user' if !shop_owner_validations(current_user_id, action) && !deliverer_validations(current_user_id, action)

    @order.send(action)
    @order.save!
    @order
  end

  def shop_orders(current_user, opts = {})
    shop = Shop.find(opts[:shop_id])
    raise ActiveRecord::RecordNotFound if current_user.id != shop.user_id

    shop.orders.page(opts[:page])
  end

  def user_orders(current_user, opts = {})
    current_user.orders.order(:created_at).page(opts[:page])
  end

  def deliverer_orders(current_user, opts = {})
    Order.where(delivery_person_id: current_user.id).page(opts[:page])
  end

  private

  def shop_owner?(current_user_id)
    @order.shop.user_id == current_user_id
  end

  def shop_owner_validations(current_user_id, action)
    shop_owner?(current_user_id) && (%w[accept reject make_ready picked]).include?(action)
  end

  def delivery_person?(current_user_id)
    @order.delivery_person_id == current_user_id
  end

  def deliverer_validations(current_user_id, action)
    delivery_person?(current_user_id) && action == 'mark_deliver'
  end
end
