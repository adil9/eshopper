# Concern for rendering various exception messages
module ExceptionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from NotAuthenticatedError do |_exception|
      render json: { message: 'You are not logged in' }, status: :unauthorized
    end

    rescue_from ActiveRecord::RecordNotFound do |_exception|
      render json: { message: 'The resource you are looking is not found' }, status: :not_found
    end

    rescue_from LatLngBlankError do |exception|
      render json: { message: exception.message }, status: :unprocessable_entity
    end
  end
end
