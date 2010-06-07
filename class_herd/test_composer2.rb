
require 'test/unit'
require 'yaml'
require 'class_herd/composer2'
require 'class_herd/composition3'
require 'class_herd/test_rewirer'
require 'monkeypatch/TestCase'

module ClassHerd
class TestComposer2 < Test::Unit::TestCase
include Test::Unit

def test_single
	#single inital class.
	c = Composer2.new(["TestRewirer::Ras"])
	assert_equal TestRewirer::Ras, c.classes
end
def chtr(name)
	"ClassHerd::TestRewirer::#{name}"
	end

def test_multiple
	comp = [chtr(:Rak),{:Lom => [chtr(:Zax)],
					:Ras => [chtr(:Kiki)]}]
	c = Composer2.new(comp)
	c = c.classes
	assert_equal TestRewirer::Rak, c
	assert c.is_duplicated?, "expected output of #{Composer2.name} to be .is_duplicated?"
	assert_equal TestRewirer::Zax, c._wiring[:Lom]
	assert_equal TestRewirer::Kiki, c._wiring[:Ras]
	
	c3 = Composition3.new.read(c)
	assert_equal comp, c3.composition
	cc = Composer2.new (c3.composition)
	assert_equal c, cc.classes
	assert_equal c._wiring, cc.classes._wiring
end
 def test_two_level
	comp = [chtr(:Rak),{:Lom => [chtr(:Zax)],
					:Ras => [chtr(:Zhaf), {
						:Gav => [chtr(:Ras)],
						:Kiki => [chtr(:Lom)]
						}]
					}]
	c = Composer2.new(comp)
	c = c.classes
	assert_equal TestRewirer::Rak, c
	assert c.is_duplicated?, "expected output of #{Composer2.name} to be .is_duplicated?"
	assert_equal TestRewirer::Zax, c._wiring[:Lom]
	assert_equal TestRewirer::Zhaf, c._wiring[:Ras]
	assert_equal TestRewirer::Ras, c._wiring[:Ras]._wiring[:Gav]
	assert_equal TestRewirer::Lom, c._wiring[:Ras]._wiring[:Kiki]
	
	c3 = Composition3.new.read(c)
	assert_equal comp, c3.composition
	cc = Composer2.new(c3.composition)
	assert_equal c, cc.classes
	assert_equal c._wiring, cc.classes._wiring
	assert_equal c._wiring[:Ras]._wiring, cc.classes._wiring[:Ras]._wiring
 end
def test_self_reference
	#wire Ras to itself.
	map = {:Lom => [chtr(:Zax)]}
	comp = [chtr(:Rak),map]
		map[:Ras] = comp
	c = Composer2.new(comp)
	c = c.classes
	#Rak creates it's Lom and Ras when it initializes, so creating one of these classes would stack overflow.
	c3 = Composition3.new.read(c)
	assert_equal_yaml comp, c3.composition
	cc = Composer2.new(c3.composition)
	assert_equal c, cc.classes
	assert_equal c._wiring, cc.classes._wiring
	assert_equal c._wiring[:Ras]._wiring, cc.classes._wiring[:Ras]._wiring
	assert_equal c._wiring[:Ras]._wiring, cc.classes._wiring
end
end;end
