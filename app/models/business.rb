class Business < ApplicationRecord
  require 'open-uri'
  require 'nokogiri'

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
  mount_uploader :photo, PhotoUploader

  after_create :add_description

  include AlgoliaSearch

  algoliasearch do
    attribute :name, :industries, :customer_interests
    searchableAttributes ['name']
  end

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

  def match_percent_with(business)
    suggestions.where(suggested_business_id: business.id).first.rating
  end

  def who_clicked_who(business)
    click_array = click_counts(business)

    if click_array.sum.zero?
      "No clicks"
    elsif click_array[0].zero?
      "They clicked"
    elsif click_array[1].zero?
      "You clicked"
    else
      "Both clicked"
    end
  end

  def mutual_clicks(business)
    click_counts(business).min
  end

  def photo_url(business)
    suggestions.photo
  end

  def p_types_desired_match(business)
    (desired_partnership_types & business.offered_partnership_types).map{ |e| PARTNERSHIP_TYPES[e.to_sym]}
  end

  def customer_skills_match(business)
    (customer_interests & business.customer_interests).map{ |e| e.name}
  end

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

  def add_description
    begin
      html_file = open(url).read unless url.nil?
    rescue
      return
    end
    html_doc = Nokogiri::HTML(html_file)

    if site_desc = html_doc.search("meta[name='description']").map{|n|n['content']}.first
      self.description = site_desc.strip
    end
    save
  end

  def add_domain
    if self.business_domain.nil? && users.first
      domain = users.first.email.match(/(?<=@).+/)[0]
     # domain = url.match(/[http[s]?:\/\/]?(?:www\.)?([\w\-]*(?:\.[a-z\.]+))/i)[-1]
      self.business_domain = domain # unless domain.nil?
      save
    end
  end

  private

  def click_counts(business)
    you_clicked_them = clicks.where(clicked_id: business.id).count
    they_clicked_you = business.clicks.where(clicked_id: id).count

    [you_clicked_them, they_clicked_you]
  end
end
