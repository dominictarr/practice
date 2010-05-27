require 'monkeypatch/autorunner'
require 'class_herd/interface_tester'
module ClassHerd
ARGV.each{ |it| 
puts it
require it}
tests = []
puts "#############"
puts "START interface tester"
puts "tests:"
ObjectSpace.each_object(Class){ |it|
	if Test::Unit::TestCase > it then
		puts "	#{it}"
		tests << it
	end
}
ints = []

puts "\nRUN TESTS\n"

tests.each{|test|
puts ""
puts 'mwmwmwmwmwmwmwmwm'
puts "TEST: #{test}"
puts '============='
ti = InterfaceTester.new(test)
puts "WRAPPED TEST #{test} ->#{ti.wrappable? ? "SUCCESS" : "FAILED"}"
puts "wmwmwmwmwmwmwmwmw"
ints = ints.concat(ti.interfaces)
}

#~ puts 'ALL INTERFACES:'
#~ ints.each {|it|
	#~ puts "#{it.test}.#{it.symbol}->#{it.int_methods.inspect}"
#~ }

puts "STOP interface tester"
puts "#############"
#exit(0)
end
