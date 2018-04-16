class SuggestionsController < ApplicationController
  def index
    current_user.business.update_suggestions!
    @suggestions = current_user.business.suggestions.order(:rating)
  end

  def update
  end
end
