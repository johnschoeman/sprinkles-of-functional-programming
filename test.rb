d = [
  30644250780,
  9003106878,
  30636278846,
  66641217692,
  4501790980,
  671_24_603036,
  131_61973916,
  66_606629_920,
  30642677916,
  30643069058,
]

a, s = [], $*[0]
s.each_byte { |b| a << ("%036b" % d[b.chr.to_i]).scan(/\d{6}/) }
a.transpose.each do |a|
  a.join.each_byte { |i| print i == 49 ? ($*[1] || "#") : 32.chr }
  puts
end

a = "test-string"

if true
  puts "hello"
end
