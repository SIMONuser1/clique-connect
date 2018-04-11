class Business < ApplicationRecord
  has_one :user
  has_many :partnerships
  has_many :partners, through: :partnerships
  has_many :competitions
  has_many :competitors, through: :competitions
  has_many :suggestions
  has_many :suggested_businesses, through: :suggestions
  has_many :clicks, foreign_key: :clicker_id
  has_many :businesses_clicked, through: :clicks, source: :clicked
  has_many :business_customer_interests
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

  # Add click associations as required

  def update_suggestions!
    suggestions.destroy_all
    Business.all.each do |business|
      next if self == business
      suggestions.create!(suggested_business: business)
    end
    # self.suggested_businesses = self.class.all.shuffle[0..9]
    # TODO
    # For the moment, it just simulates random suggestions
    # This is where the algorithm to create the suggestion objects and add ratings will go
    end
end
