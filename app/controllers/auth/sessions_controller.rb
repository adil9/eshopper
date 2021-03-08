# frozen_string_literal: true

module Auth
  # controller for sessions
  class SessionsController < Devise::SessionsController
    skip_forgery_protection
  end
end
