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

  def get_daily_suggestion
    filtered_suggestions = location_filtered_suggestions

    day = Date.today.strftime("%A")
    attempt = nil
    counter = 0

    while attempt.nil? || suggestions.include?(attempt)
      if day == 'Monday'
        # Return a below average match
        attempt = filtered_suggestions.select{ |s| s.text_rating == 'Below Average Match' }.sample
      elsif ['Tuesday', 'Wednesday', 'Thursday'].include?(day)
        # Return as good a match as possible
        attempt = filtered_suggestions[counter]
        counter += 1
      elsif day == 'Friday'
        # Return a suggestion for a business matched well with you
        other_business = filtered_suggestions.select{ |s| s.suggested_business == business }
        attempt = Suggestion.find_by(suggested_business: other_business)
      else
        return
      end
    end

    self.user_suggestions.create!(suggestion: attempt, day: day)

    # Only store 20 results
    user_suggestions.order(created_at: :desc)[20..-1].map(&:destroy) if user_suggestions.count > 20

    self.save
  end
end
