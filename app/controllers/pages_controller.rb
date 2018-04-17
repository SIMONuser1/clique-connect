class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  skip_before_action :user_needs_business, only: [:home, :welcome, :assign_business]

  def home
  end

  def welcome
    email_domain = current_user.email.match(/(?<=@).+/)[0]
    @user_business = Business.where(business_domain: email_domain).first
  end

  def assign_business
    current_user.update!(business_id: params[:business])
    redirect_to suggestions_path
  end

  def search
    # @query = params[:filters][:query]
    @query = params[:query]
    @results = Business.search(@query, { facets: '*' })
    # binding.pry
  end

  # def domain_regex(url)
  #   url.match(/[http[s]?:\/\/]?(?:www\.)?([\w\-]*(?:\.[a-z\.]+))/i)[-1]
  # end
end
