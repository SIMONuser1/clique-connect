class Suggestion < ApplicationRecord
  require 'pry-byebug'

  belongs_to :business
  belongs_to :suggested_business, class_name: 'Business'

  before_create :calculate_rating

  def calculate_rating
    des_skills_rating             = 0
    des_partnerships_rating       = 0
    click_count_rating            = 0
    customer_interests_rating     = 0
    des_partner_competitor_rating = 0
    acq_partner_competitor_rating = 0


    # Calculating against desired business skill match
    des_skills_rating += (suggested_business.business_skills.acquired.map(&:skill_id) & business.business_skills.desired.map(&:skill_id)).count

    # Check if they are on each others partnerships desired list
    if (
      business.partnerships.desired.map(&:partner_id).include?(suggested_business.id) & suggested_business.partnerships.desired.map(&:partner_id).include?(business.id)
      )
      des_partnerships_rating = 1
    end

    # # Calculate based on clicks for each other
    # clicked_on_suggested = business.businesses_clicked.where(clicked: suggested_business).first.count
    # clicked_by_suggested = suggested_business.businesses_clicked.where(clicked: business).first.count
    # unless clicked_on_suggested.zero? || clicked_by_suggested.zero?
    #   click_count_rating = (clicked_on_suggested * clicked_by_suggested) / (clicked_on_suggested + clicked_by_suggested)
    # end

    # Check if their customer interests align
    customer_interests_rating = (business.customer_interests & suggested_business.customer_interests).count

    # Check if suggested business is a competitor to desired partners
    des_partner_competitor_rating = (business.partnerships.desired.map(&:partner_id) & suggested_business.competitors.map(&:id)).count


    # Check if suggested business is a competitor to acquired partners
    acq_partner_competitor_rating = (business.partnerships.acquired.map(&:partner_id) & suggested_business.competitors.map(&:id)).count

    # insert variable weighting multipliers for each rating based on user preferences
    total_rating = [
      des_skills_rating,
      des_partnerships_rating,
      click_count_rating,
      customer_interests_rating,
      des_partner_competitor_rating,
      acq_partner_competitor_rating
    ]

    p total_rating
    self.rating = total_rating.sum
  end
end
