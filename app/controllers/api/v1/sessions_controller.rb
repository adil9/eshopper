module Api
  module V1
    # Sessions Controller
    class SessionsController < ApiController
      def logged_in_user
        render json: UserSerializer.new(current_user), status: :ok
      end

      def update_location
        current_user.update!(lat: params[:lat], lng: params[:lng])
        render json: {}, status: :ok
      end
    end
  end
end
