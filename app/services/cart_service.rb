# Service for cart management
class CartService
  def initialize(cart)
    @cart = cart
  end

  def add_or_update!(item_id, quantity)
    @item = Item.find(item_id)
    validate_cart!(quantity)
    cart_item = @cart.carts_items.find_or_create_by(item_id: item_id, status: CartsItem.statuses[:active])
    cart_item.quantity = cart_item.quantity + quantity
    cart_item.status = CartsItem.statuses[:active]
    cart_item.tax = @item.tax
    cart_item.price = @item.discounted_price
    cart_item.discount = @item.display_price - @item.discounted_price
    cart_item.save!
  end

  private

  def validate_cart!(quantity)
    raise CartError, 'Stock not available, try reducing quantity if more than 1 selected' if @item.selling_stock < quantity

    shop_ids = @cart.items.pluck(:shop_id).uniq
    raise CartError, 'Adding items to cart from different shops not allowed' if shop_ids.present? && (shop_ids.size > 1 || shop_ids.first != @item.shop_id)
  end
end
