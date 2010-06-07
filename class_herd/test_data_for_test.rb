require 'test/unit'
require 'class_herd/data_for_test'
require 'primes/TestPrimes'

module ClassHerd
class TestDataForTest < Test::Unit::TestCase
	include Test::Unit

# interface is
# initialize (test)
# print_message
# message
# result
# test

def test_simple
	dft = DataForTest.new(TestPrimes)
	
	assert dft.message
	puts dft.message
	assert String === dft.message
	assert Test::Unit::TestResult === dft.result
	assert dft.result.passed?
	assert_equal TestPrimes, dft.test
end
end;end
