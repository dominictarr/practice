require "test/unit"
require "primes/TooCleverPrimes"
require "primes/TestPrimes"

class TestTooCleverPrimes < TestPrimes 
	
	#will reuse the tests for TestPrimes, only with a different class
	def pclass  
		TooCleverPrimes
	end
end