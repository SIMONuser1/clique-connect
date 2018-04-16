module ApplicationHelper
  def sign_up_business_check
    if current_user.business
      render 'businesses/confirm_business_form'
    else
      render 'businesses/form'
    end
  end
end
