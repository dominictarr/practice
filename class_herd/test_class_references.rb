require 'test/unit'
require 'class_references4'
require 'primes/TestPrimes'
require 'class_herd/test_class_sub'
require 'class_herd/examples/outer_class'

module ClassHerd
class TestClassReferences < Test::Unit::TestCase

const_set(:ClassReferences2,ClassReferences4)

#when you parse a Class it doesn't give innerclasses... 
#which is simpler, actually!

def test_simple
	ref = ClassReferences2.new
	ref.parse(TestPrimes)
	assert_equal :TestPrimes, ref.name
	assert_equal :"Test::Unit::TestCase", ref.super_class
	assert_equal [:Primes], ref.reffs
end

def test_refclasses
	ref = ClassReferences2.new
	ref.parse(TestClassSub)

	assert_equal :"ClassHerd::TestClassSub", ref.name
	assert_equal :"Test::Unit::TestCase", ref.super_class
	assert_equal [:ClassSub,:Hello1,:Bonjour1], ref.reffs	
end

def test_innerclasses
	ref = ClassReferences2.new
	ref.parse(OuterClass)

	assert_equal :OuterClass, ref.name
	assert_equal :Object, ref.super_class
	assert_equal [:String], ref.reffs	

	ref2 = ClassReferences2.new
	ref2.parse(OuterClass::InnerClass)
	
	puts "SEXP:" + ref2.sexp.inspect
	
	assert_equal :"OuterClass::InnerClass", ref2.name
	assert_equal :Object, ref2.super_class
	assert_equal [:Integer], ref2.reffs	
end
end;end