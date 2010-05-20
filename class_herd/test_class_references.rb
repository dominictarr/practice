require 'test/unit'
require 'class_herd/class_references4'
require 'primes/TestPrimes'
require 'class_herd/test_class_sub'
require 'class_herd/examples/outer_class'
require 'monkeypatch/array'

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
	assert_equal Primes, ref.default_class(:Primes)
end

def test_refclasses
	ref = ClassReferences2.new
	ref.parse(TestClassSub)

	assert_equal :"ClassHerd::TestClassSub", ref.name
	assert_equal :"Test::Unit::TestCase", ref.super_class
	assert [:ClassSub,:Hello1,:Bonjour1].same_set?(ref.reffs)
	assert_equal ClassSub, ref.default_class(:ClassSub)
	assert_equal Hello1, ref.default_class(:Hello1)
	assert_equal Bonjour1, ref.default_class(:Bonjour1)
end

def test_innerclasses
	ref = ClassReferences2.new
	ref.parse(OuterClass)

	assert_equal :OuterClass, ref.name
	assert_equal :Object, ref.super_class
	assert_equal [:String], ref.reffs
	assert_equal String,ref.default_class(:String)

	ref2 = ClassReferences2.new
	ref2.parse(OuterClass::InnerClass)
	
	puts "SEXP:" + ref2.sexp.inspect
	
	assert_equal :"OuterClass::InnerClass", ref2.name
	assert_equal :Object, ref2.super_class
	assert_equal [:Integer], ref2.reffs
	assert_equal Integer,ref.default_class(:Integer)
end

def assert_references(klass,super_class,*refs)
	ref = ClassReferences2.new
	ref.parse(klass)
	assert (klass.name != ""), "class name cannot be empty"
	assert (super_class.name != ""), "class name cannot be empty"

	assert_equal klass.name.to_sym, ref.name, 
		"expected classname='#{klass.name}' to equal reference name='#{ref.name}'"
	assert_equal super_class.name.to_sym, ref.super_class, 
                "expected classname='#{super_class.name}' to equal reference name='#{ref.super_class}'"
	refs = refs.collect {|r| r.name.to_sym }
	assert refs.same_set?(ref.reffs), 
	"expected references for #{klass} to be the same set as:" +
"[#{(refs - ref.reffs).join(",")}<(#{(refs & ref.reffs).join(',')})>#{(ref.reffs - refs).join(',')}]"
end
def make_class (klass)
	c = klass.dup
	#eval ("Duped::Klass = nil")
	n = klass.name.split("::").last
	self.class.const_set(:"#{n}X",c)
	c
end
def test_duplicated_class
	assert_references (OuterClass,Object,String)
	#self.class.const_set(:"OuterClass1243",OuterClass.dup)
	oc = make_class(OuterClass)
	assert_references (oc,Object,String)
        oc2 = make_class(oc)
        assert_references (oc2,Object,String)
	puts "created new classes"
	puts oc
	puts oc2
	
	#ref = ClassReferences2.new
        #oc = OuterClass.dup
	#ref.parse(oc)

	#assert_equal :OuterClass, ref.name
	#assert_equal :Object, ref.super_class
	#assert_equal [:String], ref.reffs
	#assert_equal String,ref.default_class(:String)
end

end;end
