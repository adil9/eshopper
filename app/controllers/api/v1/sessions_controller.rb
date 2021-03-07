module Api
  module V1
    class SessionsController < ApiController
      def logged_in_user
        if current_user
          render json: UserSerializer.new(current_user), status: :ok
        else
          render json: {message: "Nobody Logged in"}, status: :unauthorized
        end
      end
    end
  end
end
