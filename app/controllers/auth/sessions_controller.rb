# frozen_string_literal: true

module Auth
  # controller for sessions
  class SessionsController < Devise::SessionsController
    skip_forgery_protection #Done only temporarily
    # POST /user/sign_in

    #   def new; end
    #
    #   def create
    #     user = User.where(email: user_params[:email]).first
    #     if user.valid_password?(user_params[:password])
    #       sign_in(user)
    #       redirect_to after_sign_in_path_for(user)
    #     else
    #       sign_out(current_user) if current_user
    #       flash[:notice] = 'Incorrect Email address or password'
    #       redirect_to after_sign_out_path_for(user)
    #     end
    #   end
    #
    #   # DELETE /resource/sign_out
    #   def destroy
    #     user = current_user
    #     sign_out(current_user) if current_user
    #     flash[:notice] = 'Logged out.'
    #     redirect_to after_sign_out_path_for(user)
    #   end
    #
    #
    #   # protected
    #
    #   # If you have extra params to permit, append them to the sanitizer.
    #   # def configure_sign_in_params
    #   #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    #   # end
    #
    #   private
    #
    #   def user_params
    #     params.require(:user).permit(:email, :password)
    #   end
  end
end
