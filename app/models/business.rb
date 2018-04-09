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

  enum employees: {
    :"1_to_10" => "1 to 10",
    :"11_to_50" => "11 to 50",
    :"51_to_100" => "51 to 100",
    :"101_to_500" => "101 to 500",
    :"501_to_1000" => "501 to 1000",
    :"1001_to_5000" => "1001 to 5000",
    :"5000+" => "5000+",
  }

  # Add click associations as required
  # has_many :businesses_clicked, through: :clicks, source: clicker
  # has_many :clicked_businesses, through: :clicks, source: :clicked
end
