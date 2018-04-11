namespace :test do
  desc "Loops over all sorts of weight configurations and dumps results"
  task weighting_rounds: :environment do
    results = []

    CHOICES = 2
    num_weights = Suggestion::WEIGHTS.size

    File.open('./results.txt', 'wb') do |f|
      @results = (1..CHOICES).inject([]) { |res, num| res << Array.new(num_weights, num) }
        .flatten
        .permutation(num_weights)
        .to_a
        .uniq
        .inject([]) do |results, combination|

        weights = combination.each_with_index.inject({}) do |res, (weight, index)|
          res[Suggestion::WEIGHTS.keys[index]] = weight ; res
        end

        result = `WEIGHTS='#{weights.to_yaml}' rspec`[/\d+ failures/]
        success = 100 - result.to_i

        puts "#{success}%: #{weights}"

        f.write "#{success}%: #{weights}"

        results << {result: success, weights: weights}
      end.sort { |a| a[:result] }
    end

    File.open('./sorted_results.txt', 'wb') do |f|
      @results.each do |result|
        f.write "#{result[:result]}%: #{result[:weights]}\n"
      end
    end
  end
end
