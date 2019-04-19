def is_carmichael?(limit)
  results = {}
  (2..limit).each do |num|
    (2..num).each do |b|
      left = b**num % num
      right = b % num
      # puts "b: #{b}, b**num: #{left}, b % num: #{right}"
      if right != left
        results[num] = b
        break
      end
    end
  end
  results
end

puts is_carmichael?(1000)
# puts is_carmichael?(561)
