require "test/unit"
require "TestPrimes"
require "SmartPrimes"

class TestSmartPrimes < TestPrimes 
	
	#will reuse the tests for TestPrimes, only with a different class
	def pclass  
		SmartPrimes
	end
end