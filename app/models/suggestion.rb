class Suggestion < ApplicationRecord
  belongs_to :business
  belongs_to :suggested_business, class_name: 'Business'
end
