require "test/unit"
require "TooCleverPrimes"
require "TestPrimes"

class TestTooCleverPrimes < TestPrimes 
	
	#will reuse the tests for TestPrimes, only with a different class
	def pclass  
		TooCleverPrimes
	end
end