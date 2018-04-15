require 'rubyXL' # Assuming rubygems is already required
require 'faker'

def def_current_business(row)
  Business.where(name: row.cells[0].value).first
end

puts "Clearing database..."
User.destroy_all
Suggestion.destroy_all
Click.destroy_all
BusinessCustomerInterest.destroy_all
CustomerInterest.destroy_all
Partnership.destroy_all
Competition.destroy_all
Business.destroy_all

puts "Reading excel file..."
workbook = RubyXL::Parser.parse(ENV['DB_LOCATION'])
worksheet_bus = workbook['Businesses'][1..-1]
worksheet_cli = workbook['Clicks'][1..-1]
worksheet_sug= workbook['Suggestions'][1..-1]

puts "Creating businesses and users..."
worksheet_bus.each do |row|
  des_p_types = row.cells[3].value.nil? ? [] : row.cells[3].value.split("\n").map{ |p_type| Business::PARTNERSHIP_TYPES.invert[p_type] }
  off_p_types = row.cells[4].value.nil? ? [] : row.cells[4].value.split("\n").map{ |p_type| Business::PARTNERSHIP_TYPES.invert[p_type] }
  bus_url = row.cells[9]. nil? ? "" : row.cells[9].value

  business_hash = {
    name: row.cells[0].value,
    industries: row.cells[1].value.split("\n"),
    employees: Business.employees.invert[row.cells[2].value],
    desired_partnership_types: des_p_types,
    offered_partnership_types: off_p_types,
    url: bus_url
  }
  current_business = Business.create!(business_hash)

  user = User.create!(email: Faker::Internet.email, password: 'password', password_confirmation: 'password')
  user.update!(business: current_business)
end


puts "Adding competitors..."
worksheet_bus.each do |row|
  current_business = def_current_business(row)
  competitors = row.cells[5].value.nil? ? [] : row.cells[5].value.split("\n")

  competitors.each do |competitor|
    if Business.where(name: competitor).first
      current_business.competitions.create!(competitor: Business.where(name: competitor).first)
    else
      current_business.other_competitors << competitor
      current_business.save!
    end
  end
end

puts "Adding partnerships..."
worksheet_bus.each do |row|
  current_business = def_current_business(row)

  desired_partnerships = row.cells[6].value.nil? ? [] : row.cells[6].value.split("\n")
  acquired_partnerships = row.cells[7].value.nil? ? [] : row.cells[7].value.split("\n")

  desired_partnerships.each do |des|
    if Business.where(name: des).first
      current_business.partnerships.desired.create!(partner: Business.where(name: des).first)
    else
      current_business.other_partners << des
      current_business.save!
    end
  end

  acquired_partnerships.each do |acq|
    if Business.where(name: acq).first
      current_business.partnerships.acquired.create!(partner: Business.where(name: acq).first)
    else
      current_business.other_partners << acq
      current_business.save!
    end
  end
end

puts "Adding customer interests..."
worksheet_bus.each do |row|
  current_business = def_current_business(row)
  interests = row.cells[8].value.split("\n")

  interests.each do |interest|
    current_business.business_customer_interests.create!(
      customer_interest: CustomerInterest.where(name: interest).first_or_create
    )
  end
end

puts "Adding clicks..."
worksheet_cli.each do |row|
  click_hash = {
    clicker: def_current_business(row),
    clicked: Business.where(name: row.cells[1].value).first,
    count: row.cells[2].value
  }
  # p click_hash
  Click.create!(click_hash)
end

puts "Adding suggestions..."
worksheet_sug.each do |row|
  current_business = def_current_business(row)
  current_business.update_suggestions!
end

puts "Done!"
