class Business < ApplicationRecord
  has_many :users
  has_many :partnerships, dependent: :destroy
  has_many :partners, through: :partnerships
  has_many :competitions, dependent: :destroy
  has_many :competitors, through: :competitions
  has_many :suggestions, dependent: :destroy
  has_many :suggested_businesses, through: :suggestions
  has_many :clicks, foreign_key: :clicker_id, dependent: :destroy
  has_many :businesses_clicked, through: :clicks, source: :clicked
  has_many :business_customer_interests, dependent: :destroy
  has_many :customer_interests, through: :business_customer_interests

  enum employees: {
    :"1_to_10" => "1 to 10",
    :"11_to_50" => "11 to 50",
    :"51_to_100" => "51 to 100",
    :"101_to_500" => "101 to 500",
    :"501_to_1000" => "501 to 1000",
    :"1001_to_5000" => "1001 to 5000",
    :"5000+" => "5000+",
  }

  PARTNERSHIP_TYPES = {
    ev_p: 'Event Partnerships',
    pr_p: 'PR',
    cpo_p: 'Cross Promotion Opportunities',
    tech_p: 'Technical Partnerships',
    eco_p:'Ecosystem Partnerships'
  }

  def update_suggestions!(weights = nil)
    suggestions.destroy_all

    (Business.all - [self]).each do |business|
      suggestions.create!(
        suggested_business: business,
        weights: weights
      )
    end

    suggested_businesses
  end
end
