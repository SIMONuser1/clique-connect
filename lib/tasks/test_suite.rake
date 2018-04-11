namespace :test do
  desc "Loops over all sorts of weight configurations and dumps results"
  task weighting_rounds: :environment do
    results = []

    # Suggestion::WEIGHTS.keys.each do |key|
      (1..5).each do |weight|
        weights = {
          des_skills: weight,
          des_partnerships: 2,
          click_count: 3,
          customer_interests: 2,
          des_partner_competitor: 1,
          acq_partner_competitor: 3
        }

        result = `WEIGHTS='#{weights.to_yaml}' rspec`[/\d+ failures/]

        results << {result: (100 - result.to_i), weights: weights}
      end
    # end

    results.sort { |a| a[:result] }.each do |result|
      puts "#{result[:result]}%: #{result[:weights]}"
    end
  end
end
