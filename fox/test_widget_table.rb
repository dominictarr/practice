require 'test/unit'
require 'fox16'
require 'fox/fx_widget_table'

class TestWidgetTable < Test::Unit::TestCase
include Test::Unit
include Fox

def setup
	application = FXApp.new("#{self.class}", "FoxTest")
	@frame = FXMainWindow.new(application, "#{self.class}", nil, nil, DECOR_ALL)
	application.create()
end

def test_header_simple
	header = [:name,:address,:phone]
	wt = FxWidgetTable.new(@frame,header)
	row = ["johnny","wherever he lays his hat","027 308 4466"]
	wt.add_row(row)
	assert_equal row,wt.get_rows[0]
	wt.set_widths(100,100,100)
	assert_equal 300,wt.width
end
end
