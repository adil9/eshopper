# API Controller main
module Api
  module V1
    # Base class for all API Controllers
    class ApiController < ActionController::API
      include UserAuthentication
      include ExceptionHandling
      include PaginationMeta
      before_action :authenticate_user

      private

      def log_error(error)
        Rails.logger.error error.message
        Rails.logger.error error.backtrace.join("\n")
      end
    end
  end
end
