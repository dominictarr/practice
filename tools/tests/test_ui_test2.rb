require 'rubygems'
require 'test/unit'
require 'tools/ui_tests/ui_test2'

class TestUiTest2 < Test::Unit::TestCase 


def test_step
	u = UiTest2.new
	assert_equal 0, u.steps.length
	begin
	u.step {}
	fail "expect exception if step's block doesn't have 1 arg"
	rescue; end
	u.step {|r|}
	assert_equal 1, u.steps.length
	assert_equal 0, u.step_number

	u.start_step
	sleep 0.1
	u.step_passes

	assert 0.2 > u.current_log.time
	assert u.current_log.time > 0
	assert_equal -1, u.step_number
	assert u.finished?

	u.start_step
	u.unlogged
	u.step_passes
	assert_equal 0, u.current_log.time
	assert !u.current_log.logged?
	
	#unlogged step... i.e. it might just instructions...
end


end
