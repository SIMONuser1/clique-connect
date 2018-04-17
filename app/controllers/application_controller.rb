class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :user_needs_business

#   def after_sign_up_path_for(resource_or_scope)
#     raise
#     welcome_path
#   end

  def user_needs_business
    unless current_user.business
      # raise
      redirect_to welcome_path, notice: "You must have a business"
    end
  end

  def assign_business(business)
    current_user.business = business
    redirect_to suggestions_path
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :title, :body, :photo])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :title, :body, :photo])
  end

end
