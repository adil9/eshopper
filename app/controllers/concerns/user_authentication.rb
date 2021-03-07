# Concern for user auth
module UserAuthentication
  extend ActiveSupport::Concern
  included do
    def authenticate_user
      raise NotAuthenticatedError, 'User is not logged in' unless user_signed_in?
    end
  end
end
