class SessionsController < Devise::SessionsController
  skip_before_action :user_needs_business, only: [:new, :create, :destroy]
end
