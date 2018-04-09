require "rails_helper"

RSpec.describe Suggestion, :type => :model do
  context "using Database.xlsx suggestion goals" do

    RubyXL::Parser.parse(ENV['DB_LOCATION'])['Suggestions'][1..-1].each do |suggestion|

      let(:business) { Business.find_by_name(suggestion[0]) }
      let(:suggestions) { business.update_suggestions! }

      10.times do |i|
        it "returns the #{suggestion[i]} as ##{i} suggestion for #{business.name}" do
          assert_equal suggestions[i - 1].try(:name) == suggestion[i]
        end
      end
    end

    it {  }
  end
end
