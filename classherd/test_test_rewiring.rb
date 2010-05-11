require 'test/unit'
require 'classherd/test_rewire2'

require 'classherd/test_class_rule'
require 'classherd/test_class_sub'
require 'classherd/test_data'

require 'primes/TestPrimes'
require 'primes/Primes'
require 'primes/TooCleverPrimes'
require 'primes/SmartPrimes'
require 'primes/broke_primes'

require 'factors/test_factors'
require 'factors/factors'
require 'factors/fast_factors'

module ClassHerd
class TestTestRewiring < Test::Unit::TestCase 
include Test::Unit
def test_with_primes1
	rewire = TestRewire2.new([TestPrimes],[Primes])
	rewire.run_tests
	
	data = rewire.test_data.first
	
	assert TestPrimes, data.test
	assert [Primes,Primes], data.replacement
	assert data.result.passed?
end
def test_with_all_primes
	rewire = TestRewire2.new([TestPrimes],[Primes,SmartPrimes,TooCleverPrimes,BrokePrimes])
	rewire.run_tests

	assert_equal 4, rewire.test_data.length
	puts "TESTDATA ALL:#{rewire.test_data.inspect}" 

	td = rewire.test_data.dup
	data = td[0]
	
	assert data
	assert TestPrimes, data.test
	assert [Primes,Primes], data.replacement
	assert data.result.passed?


	data = td[1]
	assert data
	puts "TESTDATA 1:#{data.inspect}" 
	
	assert TestPrimes, data.test
	assert [Primes,SmartPrimes], data.replacement
	assert data.result.passed?

	data = td[2]
	
	assert data
	assert TestPrimes, data.test
	assert [Primes,TooCleverPrimes], data.replacement
	assert data.result.passed?

	data = td[3]
	
	assert data
	assert TestPrimes, data.test
	assert [Primes,BrokePrimes], data.replacement
	assert !(data.result.passed?)
end

def test_factors
	rewire = TestRewire2.new([TestFactors],[Factors,FastFactors])
	rewire.run_tests

	assert_equal 2, rewire.test_data.length

	td = rewire.test_data.dup
	data = td.shift

	assert TestFactors, data.test
	assert [Factors,Factors], data.replacement
	assert data.result.passed?

	data = td.shift
	assert data
	
	assert TestFactors, data.test
	assert [Factors,FastFactors], data.replacement
	assert data.result.passed?
end

#this is another test which could use multiple classes

 def test_with_class_sub
	rewire = TestRewire2.new([TestClassSub],[ClassSub])
	rewire.run_tests
	
	data = rewire.test_data.first
	assert data
	assert TestClassRule, data.test
	assert [ClassSub,ClassSub], data.replacement
	assert data.result.passed?
end
class Bonjour
	def greet
		"Bonjour" 
	end
end
class Hello
	def greet
		"Hello" 
	end
end

class AnyGreeting
	def initialize(s)
		@greeting = Hello.new
		@name = s
	end
	def say
		"#{@greeting.greet}, #{@name}!"
	end
end

class AnyGreeting2 < AnyGreeting 
	def initialize (s)
		super(s)
		@greeting = Bonjour.new
	end
end

  def test_with_class_sub_many
	rewire = TestRewire2.new([TestClassSub],
		[ClassSub,Hello1,Bonjour1,AnyGreeting,AnyGreeting2])
	rewire.run_tests

	data = rewire.test_data.shift
	assert data
	assert TestClassSub, data.test
	puts "test_with_class_sub_many.replacements:\n" + data.replacement.inspect
#	assert [ClassSub,ClassSub], data.replacement
	assert !(data.result.passed?)
	
	rewire.test_data.each{|data|
	rep = data.replacement
	t1 = (rep.include?([:Hello1, Hello1]) or rep.include?([:Hello1, AnyGreeting]))
	t2 = (rep.include?([:Bonjour1, Bonjour1]) or 
				rep.include?([:Bonjour1, AnyGreeting2]))
	t = (t1 and t2)
	r = data.result.passed?
##	if (t != r) then
	##	puts data.replacement.inspect
		##puts "PASSED?==#{r}, should be == #{t.inspect} was #{t1} & #{t2}" 
		##puts data.result
	##end
	assert_equal t,r
	}
end

#as of writing, TestRewire2 is hardcoded for TestPrimes.
#write breaking test with other tests.

end;end
