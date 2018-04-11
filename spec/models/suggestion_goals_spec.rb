require "rails_helper"

RSpec.describe Suggestion, :type => :model do
  context "using Database.xlsx" do
    weights = YAML.load(ENV['WEIGHTS']) rescue Suggestion::WEIGHTS

    RubyXL::Parser.parse(ENV['DB_LOCATION'])['Suggestions'][1..-1].each do |suggestion|
      business = Business.find_by_name(suggestion[0].value)
      next unless business

      suggestions = business.update_suggestions!(weights)

      context "Suggestions for #{business.name}" do
        10.times do |i|
          next if suggestion[i.next].value.blank?
          it "##{i.next} suggestion: #{suggestion[i.next].value}" do
            assert_equal suggestion[i.next].value, suggestions[i - 1].try(:name)
          end
        end
      end
    end
  end
end
