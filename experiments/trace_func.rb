#require 'class_herd/test_test_interface'
require 'primes/TestPrimes'
require 'test/unit'
require 'test/unit/testresult'

#class Test
#	def initialize
#	end
#	def test
 #          a = 1
  #         b = 2
#	   puts "hello"
#         end
#         end
     t = Class.new(TestPrimes)
	m = t.public_instance_methods.select{|m| m =~ /^test_.*$/}
	puts m.inspect 
	def trace_on
         set_trace_func proc { |event, file, line, id, binding, classname|
#            printf "%8s %s:%-2d%-5d%10s %8s %-10s\n", event, file, line, id, classname, binding
            printf "%8s %s:%-2d %4d %8s %8s\n", event, file, line, id, classname, binding
          }
	end
#ClassHerd::TestData.new(
m.each{ |m|
puts "~~~~~~~~~~~"
puts "TRACE: #{m}"
puts "~~~~~~~~~~~"
	trace_on
	t.new(m).run(Test::Unit::TestResult.new){}
	set_trace_func(nil)
}
set_trace_func(nil)
#         t = Test.new
#         t.test
#	puts t.object_id
