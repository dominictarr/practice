require 'test/unit'
require 'class_herd/class_references4'
require 'primes/TestPrimes'
require 'monkeypatch/array'
#require ''
module ClassHerd
class TestMiniClassReferences < Test::Unit::TestCase
def ns (klass) #name symbol.
        klass.name.to_sym
end
def assert_set_eql (set1,set2,msg)
        assert set1.same_set?(set2),
        "expected sets to be eql [set1<(both)>set2]" +
"[#{(set1 - set2).join(",")}<(#{(set1 & set2).join(',')})>#{(set2 - set1).join(',')}]" +
        msg
end
def test_simple
	ref = ClassReferences4.new
        ref.parse(TestPrimes)
	
#	ref.default_class(:Primes)        

	assert_equal ns(TestPrimes), ref.name
        assert_equal Test::Unit::TestCase, ref.super_class
        assert_set_eql ([Primes], ref.ref_classes, "wrong references for #{TestPrimes}")
        #assert_equal Primes, ref.default_class(ns(Primes))
end
end;end
