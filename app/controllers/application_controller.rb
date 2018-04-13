class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :user_needs_business

  def user_needs_business
    redirect_to welcome_path, notice: "You must have a business scrub" unless current_user.business
  end

  # def after_sign_in_path_for(resource)
  #  #path_to_redirect_to
  # end

  # def after_sign_up_path_for(resource)
  #  #path_to_redirect_to
  # end
end
