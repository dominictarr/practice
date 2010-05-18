require 'monkeypatch/autorunner'
require 'class_herd/test_interface'
module ClassHerd
ARGV.each{ |it| 
puts it
require it}
tests = []
ObjectSpace.each_object(Class){ |it|
	if Test::Unit::TestCase > it then
		puts it
		tests << it
	end
}
ints = []
tests.each{|test|
puts '#############'
puts "TEST: #{test}"
puts '#############'
ti = TestInterface.new(test)
puts ti.wrappable? ? "WRAPPED SUCCESS" : "TEST FAILED"
ints = ints.concat(ti.interfaces)
}

puts 'ALL INTERFACES:'
ints.each {|it|
	puts "#{it.test}.#{it.symbol}->#{it.int_methods.inspect}"
}
end
