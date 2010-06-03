
require 'test/unit'
require 'primes/TestPrimes'
require 'class_herd/interface_tester'
require 'class_herd/interface'
require 'monkeypatch/TestCase'
require 'class_herd/test_class_rule'
require 'class_herd/test_class_sub'

module ClassHerd
class TestInterfaceTester < Test::Unit::TestCase 

def ahi_message(sym,klass,bool)
        no = bool ? "": "not"
        "expected #{klass} to #{no} have interface for #{sym}"
end

def assert_has_interface?(int,sym,klass,bool)
        assert (bool == int.has_interface?(sym,klass)), ahi_message(sym,klass,bool)
end

def test_primes
	int = InterfaceTester.new(TestPrimes)
	assert_equal [:Primes] , int.symbols
	assert_equal  Primes, int.default_class[:Primes]
	assert_sub_set int.int_methods[:Primes], ["primes"] 
	assert_has_interface?(int,:Primes,Primes,true) 
	assert_has_interface?(int,:Primes,String,false)
	begin
               	assert_has_interface?(int,:Zazu,Primes,false)
		assert false, "expected has_interface? to throw exception"
	rescue; end
 		#assert int.has_interface?(:Primes,SmartPrimes), ahi_message(:Primes,SmartPrimes,true) 
                #assert int.has_interface?(:Primes,TooCleverPrimes), ahi_message(:Primes,TooCleverPrimes,true)
		
	ints = int.interfaces
	assert ints[0].is_a? Interface
	assert TestPrimes, ints[0].test
	assert_equal [:Primes], int.symbols
	assert_equal [:primes], int.int_methods[:Primes] .collect{|it| it.to_sym}
	puts "^^^^^^^^"
	puts int.symbols.inspect
	puts ints.inspect
	j = Interface.new(TestPrimes,:Primes,int.int_methods)
	assert_equal :Primes, j.symbol
	assert_equal int.int_methods, j.int_methods
	assert_equal TestPrimes, j.test
	
	assert Symbol === ints[0].symbol, "ints[0].symbol should be a Symbol, but was :#{ints[0].symbol.class}"
	assert_equal :Primes, ints[0].symbol
	
	assert int.wrappable?
end
	def test_class_sub
		#~ puts "&&&&&&&&&&&&&"
		int = InterfaceTester.new(TestClassSub)
		assert int.wrappable?, "expected test to be wrappable"
		assert_equal [:ClassSub,:Bonjour1,:Hello1] , int.symbols
		assert_has_interface?(int,:ClassSub,ClassSub,true)
                assert_has_interface?(int,:Bonjour1,Bonjour1,true)
                puts "&&&&&&&&&&&&&"
		#~ puts int.interfaces.inspect
		assert_equal ["say"], int.int_methods[:Bonjour1]
		puts int.int_methods[:ClassSub]
		#assert_equal ["sub"], int.int_methods[:ClassSub]
		assert_has_interface?(int,:Bonjour1,ClassSub,false)
                assert_has_interface?(int,:Hello1,ClassSub,false)
	#assert_equal  Primes, int.default_class[:Primes]
	end
	def test_class_rule
		int = InterfaceTester.new(TestClassRule)
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
