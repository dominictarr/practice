require 'test/unit'
require 'fox16'
require 'fox/fx_widget_row'

class TestWidgetRow < Test::Unit::TestCase
include Test::Unit
include Fox
@@application = FXApp.new("#{self.class}", "FoxTest")
def setup
	@frame = FXMainWindow.new(@@application, "#{self.class}", nil, nil, DECOR_ALL)
end

def teardown
	#puts "TEARDOWN #{@@application.inspect}"
	#@@application.closeDisplay
end

def test_row_simple
	row = ["johnny","wherever he lays his hat","027 308 4466"]
	wt = FxWidgetRow.new(@frame,row)
	assert_equal row,wt.row_data
	wt.set_widths(100,100,110)
	assert_equal 310,wt.width
end

def test_reorder
#i'll use this stuff to make drag and drop...
	row = ["johnny","wherever he lays his hat","027 308 4466"]
	wt = FxWidgetRow.new(@frame,row)
	assert_equal row,wt.row_data

	wt.shift_right(0)
	a = row.delete_at(0)
	row.insert(1,a)
	assert_equal row,wt.row_data

	wt.shift_left(0)#no change, boundry case
	assert_equal row,wt.row_data
	wt.shift_right(2)#no change, boundry case
	assert_equal row,wt.row_data

	wt.shift_after(0,2)
	a = row.delete_at(0); row << a
	assert_equal row,wt.row_data

	wt.shift_before(1,0)
	a = row.delete_at(1); row = [a] + row
	assert_equal row,wt.row_data
end


#

end
