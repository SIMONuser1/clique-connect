class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  skip_before_action :user_needs_business, only: [:welcome]

  def home
  end

  def welcome

  end
end
