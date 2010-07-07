require 'rubygems'
require 'test/unit'
require 'count_ones'
require 'count_ones2'

class TestCountOnes < Test::Unit::TestCase
include Test::Unit

def test_one
	c = CountOnes2.new
	assert_equal 0, c.f(0)
	assert_equal 1, c.f(1)
	assert_equal 2, c.f(10)
	assert_equal 4, c.f(11)
	assert_equal 12, c.f(20)

	assert_equal 21, c.f(100)
	assert_equal 199991, c.f(199991)
#	assert_equal 200001, c.f(200001)
end
end
