require 'test/unit'
require 'reference'

module ClassHerd
class TestReference < Test::Unit::TestCase 
include Test::Unit
def test_reference
	r = Reference.new([:const, :hello, :I, :am, :a, :classname])
	assert_equal [:hello, :I, :am, :a, :classname], r.symbols
end

end
end