class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :business
  has_many :notes, foreign_key: :author_id
  has_many :user_suggestions, dependent: :destroy
  has_many :suggestions, through: :user_suggestions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :business, required: false

  mount_uploader :avatar, AvatarUploader

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def location_filtered_suggestions
    if location.nil?
      business.suggestions.order(:rating)
    else
      business.suggestions.all.inject([]) do |mem, sug|
        mem << sug if sug.suggested_business.locations.include?(location)
        mem
      end
    end
  end

  def last_ten_suggestions
    # raise
    filtered_suggestions = location_filtered_suggestions
    # raise
    last_ten = user_suggestions.order(created_at: :desc)[0..9].map(&:suggestion)
    counter = 0
    # raise
    while last_ten.count < 10
      # Fill up the list with unqiue high rating entries
      last_ten = last_ten | [filtered_suggestions[counter]]
      counter += 1
    end

    last_ten
  end

  def remove_previous_suggestions(list)
    list - self.suggestions
  end

  def get_daily_suggestion
    filtered_suggestions = remove_previous_suggestions(location_filtered_suggestions)
    return if filtered_suggestions.nil? || filtered_suggestions.empty?

    day = Date.today.strftime("%A")
    # testing
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    day = days.sample

    if day == 'Monday'
      # Return a below average match
      bad_list = filtered_suggestions.select{ |s| s.text_rating == 'Below Average Match' }
      attempt = bad_list.empty? ? filtered_suggestions.sample : bad_list.sample

    elsif ['Tuesday', 'Wednesday', 'Thursday'].include?(day)
      # Return as good a match as possible
      attempt = filtered_suggestions.first

    elsif day == 'Friday'
      # Return a suggestion for a business matched well with you
      attempts = Suggestion.where(suggested_business: business)
        .inject([]) do |mem, sug|
          if sug.business.locations.include?(location)
            mem << Suggestion.find_by(business: business, suggested_business: sug.business)
          end
          mem
        end

      # nested while loop so that attempts is only calculated once
      attempts = remove_previous_suggestions(attempts)
      return if attempts.empty?
      attempt = attempts.first
    else
      return
    end

    self.user_suggestions.create!(suggestion: attempt, day: day)

    # Only store 20 results
    user_suggestions.order(created_at: :desc)[20..-1].map(&:destroy) if user_suggestions.count > 20

    self.save!
  end
end
