

require 'test/unit'
require 'test/unit/testresult'
require 'TestPrimes'
require 'Primes'
require 'TooCleverPrimes'
require 'SmartPrimes'
include Test::Unit

def runtest(test_klass,method,subject)
	tr = TestResult.new();
	tr.add_listener(TestResult::FAULT) {|value| puts "HEARD:" + value.to_s}
	#tr.notify_listeners("test","notify")

#puts "TEST CLASS:" + test_klass.to_s

test_klass.new(method,subject).run(tr) {|status, name| 
		if (status == TestCase::FINISHED)
		puts "\t" + name + ":" + tr.to_s
		end
		}
end

#TestPrimes.new("test_fail").run(TestResult.new()) 

#runtest(TestPrimes,"test_fail");
#runtest(TestPrimes,"test_error");

#puts TestPrimes.public_instance_methods.find_all{|it| it.to_s =~ /test_.*/ }

the_test = TestPrimes
tests = the_test.public_instance_methods.find_all{|it| it.to_s =~ /test_.*/ }

subject = [Primes,TooCleverPrimes,SmartPrimes]
subject.each {|sub| 
	puts "TESTING: " + sub.to_s
	tests.each {|method|
			runtest(the_test,method,sub)
		}
	}

