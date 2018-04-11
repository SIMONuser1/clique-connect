namespace :test do
  desc "Loops over all sorts of weight configurations and dumps results"
  task weighting_rounds: :environment do
    results = []

    # Duplicate but set all weights to 1
    weights = Suggestion::WEIGHTS.inject({}) do |res, (k, v)|
      res[k] = 1 ; res
    end

    (1..5).each do |x|
      weights.keys.each do |key|
        (1..5).each do |weight|
          weights[key] = weight

          # result = `WEIGHTS='#{weights.to_yaml}' rspec`[/\d+ failures/]

          results << {result: (100 - 'result'.to_i), weights: weights.dup}
        end
        weights[key] = x
      end
    end
    results.sort { |a| a[:result] }
    results.each do |result|
      puts "#{result[:result]}%: #{result[:weights]}"
    end
  end
end
