class Business < ApplicationRecord
  has_one :user
  has_many :business_skills
  has_many :skills, through: :business_skills
  has_many :partnerships
  has_many :partners, through: :partnerships
  has_many :competitions
  has_many :competitors, through: :competitions
  has_many :suggestions
  has_many :suggested_businesses, through: :suggestions

  # Add click associations as required
  # has_many :businesses_clicked, through: :clicks, source: clicker
  # has_many :clicked_businesses, through: :clicks, source: :clicked
end
