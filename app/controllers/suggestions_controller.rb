class SuggestionsController < ApplicationController
  def index
    @suggestions = current_user.business.suggestions
  end

  def update
  end
end
