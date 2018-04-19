class SuggestionsController < ApplicationController
  def index
    current_user.business.update_suggestions!
    @suggestions = current_user.business.suggestions.order(:rating)
  end

  def update
  end

  def matched_business
    current_user.business.update_suggestions!
    @suggestions = current_user.business.remove_self_from_list(current_user.business.who_matched_with_me)
  end

  def hail_mary
    @suggestions = current_user.business.remove_self_from_list(current_user.business.suggestions).sample(10)
  end
end
