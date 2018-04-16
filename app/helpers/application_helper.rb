module ApplicationHelper
  def sign_up_business_check(user_business)
    unless @user_business.nil?
      render 'businesses/confirm_business_form', user_business: user_business
    else
      render 'businesses/form', business: Business.new
    end
  end
end
