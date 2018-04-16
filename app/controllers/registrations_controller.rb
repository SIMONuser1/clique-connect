class RegistrationsController < Devise::RegistrationsController
  skip_before_action :user_needs_business, only: [:new, :create, :destroy]
end
