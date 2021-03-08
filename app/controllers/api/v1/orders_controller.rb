module Api
  module V1
    # Controller for order management APIs
    class OrdersController < ApiController
      include PaginationMeta
      before_action :set_order, only: %i[show update]
      def checkout
        cart = Cart.includes(carts_items: :item).where(user_id: current_user.id).first
        raise ActiveRecord::RecordNotFound if cart.nil?

        order_service = OrderService.new
        order = order_service.prepare_order(current_user.id, params[:payment_method], cart)
        render json: OrderSerializer.new(order, options), status: :ok
      end

      def update
        order = OrderService.new(@order).update_status(current_user.id, params[:order_action])
        render json: OrderSerializer.new(order, options), status: :ok
      rescue AASM::InvalidTransition
        render json: { message: 'This state update is invalid' }, status: :unprocessable_entity
      rescue NotAllowedError => e
        render json: { message: e.message }, status: :unauthorized
      end

      def index
        if %w[shop user deliverer].include?(params[:from])
          orders = OrderService.new.send("#{params[:from]}_orders", current_user, search_params)
          render json: OrderSerializer.new(orders, meta: pagination_dict(orders)), status: :ok
        else
          render json: { message: 'Bad Parameters' }, status: :bad_request
        end
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Record not found' }, status: :not_found
      end

      def show
        render json: OrderSerializer.new(@order, options), status: :ok
      end

      private

      def set_order
        @order = Order.includes(orders_items: :item).find_by(order_no: params[:id])
      end

      def options
        options = {}
        options[:include] = %i[orders_items orders_items.item]
        options
      end

      def search_params
        params.permit(:shop_id, :page)
      end
    end
  end
end
