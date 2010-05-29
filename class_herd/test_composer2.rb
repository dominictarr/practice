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
end
def test_two_level
end
def test_self_reference
end
end;end
