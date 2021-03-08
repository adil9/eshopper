# frozen_string_literal: true

module Auth
  # Enable Basic Registration Process
  class RegistrationsController < Devise::RegistrationsController
    skip_forgery_protection
  end
end
