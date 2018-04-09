require 'rubyXL' # Assuming rubygems is already required
require 'pry-byebug'

puts "Clearing database..."
Partnership.destroy_all
Competition.destroy_all
BusinessSkill.destroy_all
Skill.destroy_all
Business.destroy_all

puts "Reading excel file..."
workbook = RubyXL::Parser.parse(ENV['DB_LOCATION'])
worksheet = workbook['Businesses'][1..-1]

puts "Creating businesses and business skills..."
worksheet.each do |row|
  business_hash = {
    name: row.cells[0].value,
    industries: row.cells[1].value.split("\n"),
    employees: Business.employees.invert[row.cells[2].value]
  }
  current_business = Business.create!(business_hash)

  desired_skills = row.cells[3].value.split("\n")
  acquired_skills = row.cells[4].value.split("\n")

  # (desired_skills + acquired_skills).each do |skill|
  #   Skill.create!(name: skill) unless Skill.where(name: skill)
  # end

  desired_skills.each do |des|
    current_business.business_skills.desired.create!(skill: Skill.where(name: des).first_or_create)
  end

  acquired_skills.each do |acq|
    current_business.business_skills.acquired.create!(skill: Skill.where(name: acq).first_or_create)
  end
end


puts "Adding competitors..."
worksheet.each do |row|
  current_business = Business.where(name: row.cells[0].value).first
  competitors = row.cells[5].value.split("\n")

  competitors.each do |competitor|
    if Business.where(name: competitor).first
      current_business.competitions.create!(competitor: Business.where(name: competitor).first)
    else
      current_business.other_competitors << competitor
    end
  end
end

puts "Adding partnerships..."
worksheet.each do |row|
  current_business = Business.where(name: row.cells[0].value).first

  desired_partnerships = row.cells[6].nil? ? [] : row.cells[6].value.split("\n")
  acquired_partnerships = row.cells[7].nil? ? [] : row.cells[7].value.split("\n")

  desired_partnerships.each do |des|
    if Business.where(name: des).first
      current_business.partnerships.desired.create!(partner: Business.where(name: des).first)
    else
      current_business.other_partners << des
    end
  end

  acquired_partnerships.each do |acq|
    if Business.where(name: acq).first
      current_business.partnerships.acquired.create!(partner: Business.where(name: acq).first)
    else
      current_business.other_partners << acq
    end
  end
end

puts "Done!"
