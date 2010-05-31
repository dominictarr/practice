require 'test/unit'
require 'yaml'
require 'class_herd/composer2'
require 'class_herd/test_rewirer'

module ClassHerd
class TestComposer2 < Test::Unit::TestCase
include Test::Unit

def test_single
	#single inital class.
	c = Composer2.new (["TestRewirer::Ras"])
	assert_equal TestRewirer::Ras, c.classes
end

def test_multiple
	c = Composer2.new (
	["TestRewirer::Rak",{"Lom" => ["TestRewirer::Zax"],
					"Ras" => ["TestRewirer::Kiki"]}])
	c = c.classes
	assert_equal TestRewirer::Rak, c
	assert c.is_duplicated?, "expected output of #{Composer2.name} to be .is_duplicated?"
	assert_equal TestRewirer::Zax, c._wiring[:Lom]
	assert_equal TestRewirer::Kiki, c._wiring[:Ras]
end
#~ def test_two_level
#~ end
#~ def test_self_reference
#~ end
end;end
