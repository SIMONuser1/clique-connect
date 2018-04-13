class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # def after_sign_in_path_for(resource)
  #  #path_to_redirect_to
  # end

  # def after_sign_up_path_for(resource)
  #  #path_to_redirect_to
  # end
end
