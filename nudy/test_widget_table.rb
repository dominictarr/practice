require 'test/unit'
require 'fox16'


class TestWidgetTable < Test::Unit::TestCase
include Test::Unit::TestCase
include Fox

def test_header_simple
	header = [:name,:address,:phone]
	wt = FxWidgetTable.new(frame,header)
	row = ["johnny","wherever he lays his hat","027 308 4466"]
	wt.addRow(*row)
	assert_equal row,wt.getRow
	wt.set_widths(100,100,100)
	assert_equal 300,wt.width
end
end
