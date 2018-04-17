class SessionsController < Devise::SessionsController
  skip_before_action :user_needs_business, only: [:new, :create, :destroy]

  def after_sign_in_path_for(resource)
    suggestions_path #your path
  end
end
