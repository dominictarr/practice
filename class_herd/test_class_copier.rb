require 'test/unit'
require 'class_herd/class_copier'
require 'class_herd/examples/outer_class'
require 'class_herd/class_references4'
require 'class_herd/examples/inheritence_examples'

module ClassHerd
class TestClassCopier < Test::Unit::TestCase

def assert_copy_basics(klass)
       # klass = OuterClass
        cc = ClassCopier.new
        cr = ClassReferences4.new
        cr2 = ClassReferences4.new
        c = cc.copy(klass)
        real = cr.parse(c)
        fake = cr2.parse(klass)
        assert_equal cr.reffs,cr2.reffs
        
 #       puts "REAL: #{real}"
  #      puts "FAKE: #{fake}"
        
        cr.reffs.each{|sym|
                assert_equal cr.default_class(sym),cr2.default_class(sym)
        }
end

def test_copy_simple
	klass = OuterClass
	cc = ClassCopier.new
	cr = ClassReferences4.new
        cr2 = ClassReferences4.new
	c = cc.copy(klass)
	real = cr.parse(klass)
	fake = cr2.parse(c)
	assert_equal cr.reffs,cr2.reffs

	#puts "REAL: #{real}"
	#puts "FAKE: #{fake}"

	cr.reffs.each{|sym|
		assert_equal cr.default_class(sym),cr2.default_class(sym), "default classes should be the same, copied or not"
	}
end

def test_copy_core
	assert_copy_basics(Array)
       	assert_copy_basics(Hash)
       	assert_copy_basics(String)
       	assert_copy_basics(Class)
end

def assert_comp(c1,c2,func,b_forward,b_backward)
	assert c1.send(func,c2) == b_forward, "expected #{c1}.#{func}(#{c2}) == #{b_forward}"
	assert c2.send(func,c1) == b_backward, "expected #{c2}.#{func}(#{c1}) == #{b_backward}"
end
def assert_copy_equal(c1,c2)
	[:==,:eql?].each{|func|
	assert_comp(c1,c2,func,true,true)
	}
        assert_comp(c1,c2,:equal?,false,false)
	#equal? means object_id equal.
	#people probably use this for classes, because they don't expect
	#classes to be different objects but the same class, but hey, 
	#the programming world has just changed.
end
def test_copy_comparison
      cc = ClassCopier.new
   	assert_copy_equal(String,cc.copy(String))
	assert_copy_equal("hello",cc.copy(String).new("hello"))

        assert_copy_equal(Array,cc.copy(Array))
        assert_copy_equal([:a,:b,:c],cc.copy(Array).new([:a,:b,:c]))

	assert_copy_equal(Class,cc.copy(Class))
	assert_copy_equal(Module,cc.copy(Module))
end

def multi_copy(klass, cc, n)
	if (n > 0) then
		return multi_copy(cc.copy(klass),cc,n - 1)
	else
		return klass
	end
end

def test_multi_copy
      	cc = ClassCopier.new
	n = 2
	s = multi_copy(String,cc,n)
        assert_copy_equal(String,s)
        assert_copy_equal("hello",s.new("hello"))

	a = multi_copy(Array,cc,n)
        assert_copy_equal(Array,a)
        assert_copy_equal([:a,:b,:c],a.new([:a,:b,:c]))

	c = multi_copy(Class,cc,n)
        assert_copy_equal(Class,c)
	
	m = multi_copy(Module,cc,n)
        assert_copy_equal(Module,m)
end

def assert_subclass(super_class,sub_class)

	assert_comp(super_class,sub_class, :>,true,false)
        assert_comp(super_class,sub_class, :>=,true,false)
         assert_comp(super_class,sub_class, :<,false,true)
         assert_comp(super_class,sub_class, :<=,false,true)
end

def test_inheritence
	cc = ClassCopier.new
	c1 = cc.copy(Class1)
	c2a = cc.copy(Class2a)
        c2b = cc.copy(Class2b)
	c3 = cc.copy(Class3)

	assert_subclass(c1,c2a)
	assert_subclass(c1,c2b)
       	assert_subclass(c1,c3)
	assert_subclass(c2b,c3)
	#should i also add copied classes to ancestors? 
end
end;end

