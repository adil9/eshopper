# Concern for user auth
module Validation
  extend ActiveSupport::Concern
  included do
    def validate_lat_lng
      raise LatLngBlankError, 'User address not set' if current_user.lat.blank? || current_user.lng.blank?
    end
  end
end
