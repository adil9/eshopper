module Api
  module V1
    # Controller for shop listing and management APIs
    class ShopsController < ApiController
      include Validation
      before_action :validate_lat_lng, only: :index
      before_action :set_shop, only: %i[show rate]
      def index
        # Currently kept it un paginated
        shops = Shop.within(CONFIG[:shop_search_radius], origin: [current_user.lat, current_user.lng])
        render json: ShopSerializer.new(shops), status: :ok
      end

      def show
        render json: ShopSerializer.new(@shop), status: :ok
      end

      def rate
        if current_user.orders.where(shop_id: @shop.id).blank?
          render json: { message: 'You cannot rate a shop without ordering' }, status: :unauthorized
        else
          rating = Rating.find_or_initialize_by(user_id: current_user.id, shop_id: @shop.id)
          rating.update!(rating: params[:rating], description: params[:description])
          render json: { message: 'success' }, status: :ok
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      private

      def set_shop
        @shop = Shop.find(params[:id])
      end
    end
  end
end
