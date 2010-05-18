
require 'test/unit'
require 'primes/TestPrimes'
require 'class_herd/test_interface'
require 'class_herd/interface'
require 'monkeypatch/array'
require 'class_herd/test_class_rule'

module ClassHerd
class TestTestInterface < Test::Unit::TestCase 
	def test_primes
		int = TestInterface.new(TestPrimes)
		assert_equal [:Primes] , int.symbols
		assert_equal  Primes, int.default_class[:Primes]
		assert_sub_set int.methods[:Primes], ["primes"] 
		assert int.has_interface?(:Primes,Primes)
		
		ints = int.interfaces
		assert ints[0].is_a? Interface
		assert TestPrimes, ints[0].test
		assert_equal :Primes, ints[0].symbol
		
		assert int.wrappable?
	end
	def assert_same_set (s1,s2)
		assert s1.same_set?(s2), "expected #{s1.inspect}.same_set? #{s2.inspect}"
	end
        def assert_sub_set (s1,s2)
                assert s1.sub_set?(s2), "expected #{s1.inspect}.sub_set? #{s2.inspect}"
        end
	def test_class_rule
		int = TestInterface.new(TestClassRule)
		assert [:ClassRule,:Integer, :String, :Array, :Numeric].same_set? int.symbols
		assert int.wrappable?, "this is failing until the Interface Discovery Wrapper is improved: <#{int.data.message}>"
		#int.methods[:ClassRule].inspect + ">>>"
 
		assert_equal  ClassRule, int.default_class[:ClassRule]
		#assert_same_set ["test", "test?", "wrap", "dowrap", "replace", "replace?"], int.methods[:ClassRule]
		#puts "<<<" + int.methods[:ClassRule].inspect + ">>>"
		assert int.has_interface?(:ClassRule,ClassRule), "int.has_interface?(:ClassRule,ClassRule)"
		#assert int.wrappable?, "this is failing until the Interface Discovery Wrapper is improved."
	end
end;end
