require 'test/unit'
require 'class_herd/class_references4'
require 'primes/TestPrimes'
require 'class_herd/test_class_sub'
require 'class_herd/examples/outer_class'
require 'monkeypatch/array'
require 'class_herd/class_conductor3'
require 'class_herd/class_copier'

require 'class_herd/examples/empty_class'

require 'class_herd/class_finder'
require 'class_herd/interface'
require 'class_herd/interface_discovery_wrapper'

require 'sexp_processor'

module ClassHerd
class TestClassReferences < Test::Unit::TestCase

#const_set(:ClassReferences4,ClassReferences4)

#when you parse a Class it doesn't give innerclasses... 
#which is simpler, actually!

def test_simple
	ref = ClassReferences4.new
	ref.parse(TestPrimes)
	assert_equal ns(TestPrimes), ref.name
	assert_equal Test::Unit::TestCase, ref.super_class
	assert_set_eql ([Primes], ref.ref_classes, "wrong references for #{TestPrimes}")
	assert_equal Primes, ref.default_class(ns(Primes))
end

#how to automaticially calculate the local name of a class?
#thats related to what ClassFinder does.

def ns (klass) #name symbol.
	klass.name.to_sym
end

def test_refclasses
	ref = ClassReferences4.new
	ref.parse(TestClassSub)

	assert_equal ns(TestClassSub), ref.name
	assert_equal Test::Unit::TestCase, ref.super_class

	assert_set_eql ([ClassSub,Hello1,Bonjour1],ref.ref_classes,
		"wrong references for #{TestClassSub}")

	#assert_set_eql ([ns(ClassSub),ns(Hello1),ns(Bonjour1)],ref.reffs,"wrong references for #{TestClassSub}")
	assert_equal ClassSub, ref.default_class(ns(ClassSub))
	assert_equal Hello1, ref.default_class(ns(Hello1))
	assert_equal Bonjour1, ref.default_class(ns(Bonjour1))
end

def test_innerclasses
	ref = ClassReferences4.new
	ref.parse(OuterClass)

	assert_equal ns(OuterClass), ref.name
	assert_equal Object, ref.super_class
        assert_equal [String], ref.ref_classes
 	#assert_equal [ns(String)], ref.reffs
	assert_equal String,ref.default_class(ns(String))

	ref2 = ClassReferences4.new
	ref2.parse(OuterClass::InnerClass)
	
	puts "SEXP:" + ref2.sexp.inspect
	
	assert_equal ns(OuterClass::InnerClass), ref2.name
	assert_equal Object, ref2.super_class
	#assert_set_eql ([ns(Integer)], ref2.reffs, "wrong references for #{OuterClass::InnerClass}")
	assert_set_eql ([Integer], ref2.ref_classes, "wrong references for #{OuterClass::InnerClass}")

	assert_equal Integer,ref.default_class(ns(Integer))
end

def assert_set_eql (set1,set2,msg = "")
        assert set1.same_set?(set2),
        "expected sets to be eql [set1<(both)>set2]" +
"[#{(set1 - set2).join(",")}<(#{(set1 & set2).join(',')})>#{(set2 - set1).join(',')}]" + 
	msg
end

def assert_references(klass,super_class,*refs)
	ref = ClassReferences4.new
	ref.parse(klass)
	assert (klass.name != ""), "class name cannot be empty"
	assert (super_class.name != ""), "class name cannot be empty"

	assert_equal klass.name.to_sym, ref.name, 
		"expected classname='#{klass.name}' to equal reference name='#{ref.name}'"
	assert_equal super_class, ref.super_class, 
                "expected classname='#{super_class}' to equal reference name='#{ref.super_class}'"
	#refs = refs.collect {|r| r.name.to_sym }
	assert_set_eql(refs,ref.ref_classes, "wrong references for #{klass}")
	#assert_set_eql(refs,ref.reffs, "wrong references for #{klass}")
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
	
	#ref = ClassReferences4.new
        #oc = OuterClass.dup
	#ref.parse(oc)

	#assert_equal :OuterClass, ref.name
	#assert_equal :Object, ref.super_class
	#assert_equal [:String], ref.reffs
	#assert_equal String,ref.default_class(:String)

end

def test_self_reference #why did I forget to test self reference for this long?

ref = ClassReferences4.new

#	puts "------------------
#	    TEST SELF REFERENCE
#		----------------"
	ref.parse(ClassReferences4)
	
	assert_equal ns(ClassReferences4), ref.name
	assert_equal SexpProcessor, ref.super_class

	#goodrefs = [Exception, ClassHerd::ClassFinder, ClassHerd::Parser, Symbol]
	puts "ClassREfernece4.reffs:" + ref.reffs.inspect
	puts "ClassREfernece4.ref_classes:" + ref.ref_classes.inspect
end

def assert_wrapped_references(straight, wrapped)
ref1 = ClassReferences4.new
ref2 = ClassReferences4.new
ref1.parse(straight)
ref2.parse(wrapped)

	assert_equal ns(straight), ref1.name
	assert_equal ns(wrapped), ref2.name

	assert_equal straight.superclass, ref1.super_class
	assert_equal wrapped.superclass, ref2.super_class

	assert_set_eql ref1.reffs,ref2.reffs
end
include ClassHerd::ClassConductor3
def test_self_reference_wrapped #why did I forget to test self reference for this long?

	puts "-------------------"
	puts "-TEST SELF REFERENCE - Wrapped"
	puts "-------------------"

idw = InterfaceDiscoveryWrapper.new
cc = ClassCopier.new
#k = idw.wrap(EmptyClass
puts "\n@--------Wrapping with ClassCopier"
klasses = [EmptyClass,TestPrimes,TestPrimes,ClassReferences4,Array, Integer, String]

klasses.each{|klass|
	puts "--->#{klass}"
cr_k = cc.copy(klass)
assert_wrapped_references(klass,cr_k)
}
puts "\n@--------Wrapping with ClassConductor3"
klasses.each{|klass|
	puts "--->#{klass}"
cr_k = _on(klass)
assert_wrapped_references(klass,cr_k)
}
puts "\n@--------Wrapping with InterfaceDiscoveryWrapper"
klasses.each{|klass|
cr_k = idw.wrap(klass)
	puts "--->#{klass}"
assert_wrapped_references(klass,cr_k)
}

#~ ref2 = cr_k.new
#~ ref3 = ClassReferences4.new

	#~ ref1.parse(cr_k)
	#~ ref2.parse(cr_k)
	#~ ref3.parse(ClassReferences4)
	
	#~ assert_equal ns(cr_k), ref1.name
	#~ assert_equal ns(cr_k), ref2.name
	#~ assert_equal SexpProcessor, ref1.super_class
	#~ assert_equal SexpProcessor, ref2.super_class

	#~ assert_set_eql ref3.reffs,ref1.reffs
	#~ assert_set_eql ref3.reffs,ref2.reffs

#	puts "#{cr_k}.reffs:" + ref.reffs.inspect
#	puts "#{cr_k}.ref_classes:" + ref.ref_classes.inspect
end


#def test_rewire
#	puts "\n"
#	puts "#############"
#	puts "#test_rewire#"
#	puts "#############"
#	idw = InterfaceDiscoveryWrapper.new
#	p = idw.wrap(Primes)
#	tp = _on(TestPrimes)._replace(:Primes,p)
#	assert_references(tp,Test::Unit::TestCase,p)
#	cr = ClassReferences4.new
#	cr.parse(tp)
#	puts "#{cr.reffs.inspect}"
#end

end;end

