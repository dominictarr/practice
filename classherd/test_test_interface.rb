
require 'test/unit'
require 'primes/TestPrimes'
require 'test_interface'
require 'monkeypatch/array'
require 'test_class_rule'

module ClassHerd
class TestTestInterface < Test::Unit::TestCase 
	
	def test_primes
		int = TestInterface.new(TestPrimes)
		assert_equal [:Primes] , int.symbols
		assert_equal  Primes, int.default_class[:Primes]
		assert_equal  ["primes"], int.methods[:Primes] 
		assert int.has_interface?(:Primes,Primes)
		assert int.wrappable?
	end
	def test_class_rule
		int = TestInterface.new(TestClassRule)
		assert [:ClassRule,:Integer, :String, :Array, :Numeric].same_set? int.symbols
		assert_equal  ClassRule, int.default_class[:ClassRule]
		assert ["test", "test?", "wrap", "dowrap", "replace", "replace?"].same_set? int.methods[:ClassRule] 
		assert int.has_interface?(:ClassRule,ClassRule)
		assert int.wrappable?
	end

end;end
