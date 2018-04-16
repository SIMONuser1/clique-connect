class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  skip_before_action :user_needs_business, only: [:home, :welcome]
  def home
  end

  def welcome
    email_domain = current_user.email.match(/(?<=@).+/)[0]
    @user_business = Business.where(business_domain: email_domain).first
    # raise
  end

  def domain_regex(url)
    url.match(/[http[s]?:\/\/]?(?:www\.)?([\w\-]*(?:\.[a-z\.]+))/i)[-1]
  end
end
