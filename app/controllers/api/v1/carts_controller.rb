module Api
  module V1
    # Controller for cart management APIs
    class CartsController < ApiController
      before_action :set_cart, only: %i[list_item update_item]
      def update_item
        cart_service = CartService.new(@cart)
        cart_service.add_or_update!(params[:item_id], params[:item_quantity].to_i)
        render json: CartSerializer.new(@cart, options), status: :ok
      rescue CartError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      def list_item
        render json: CartSerializer.new(@cart, options), status: :ok
      end

      private

      def set_cart
        @cart = Cart.includes(carts_items: :item).where(user_id: current_user.id).first
      end

      def options
        options = {}
        options[:include] = %i[carts_items carts_items.items]
        options
      end

      def cart_params
        params.permit(:item_id, :item_quantity)
      end
    end
  end
end
