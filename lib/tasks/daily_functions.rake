namespace :daily_functions do
  desc "Functions to be exectuted daily"
  task update_daily_suggestions: :environment do
    User.all.map(&:get_daily_suggestion)
  end

end
