module Api
  module V1
    # Controller for shop listing and management APIs
    class ItemsController < ApiController
      def index
        items = Item.where(search_params).page(params[:page])
        render json: ItemSerializer.new(items, meta: pagination_dict(items)), status: :ok
      end

      def show
        item = Item.find(params[:id])
        render json: ItemSerializer.new(item), status: :ok
      end

      private

      def search_params
        params.permit(:category, :shop_id)
      end
    end
  end
end
