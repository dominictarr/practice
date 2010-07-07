require 'tools/tool_state'
require 'test/unit'
require 'monkeypatch/TestCase'

class TestToolState < Test::Unit::TestCase
include Test::Unit
#states
#shelf,borrowed,in_use,misplaced,lost
#acceptable transitions:

# shelf -> misplaced,borrowed,in_use
# borrowed -> shelf, lost
# misplaced -> lost, shelf
# lost -> shelf
# in_use -> shelf, borrowed, misplaced

def states
	[:shelf,:in_use,:borrowed,:misplaced,:lost]
end

def test_simple
	puts "HELLO!"
	ts = ToolState.new

	assert ts.current_state, "initial state must be non nil"

	assert_same_set states,ts.possible_states

	assert_equal :shelf, ts.current_state

	assert_same_set [:in_use,:borrowed,:misplaced] ,ts.transitions
	ts.transit :in_use

	assert_same_set [:shelf,:borrowed,:misplaced] ,ts.transitions
	ts.transit :borrowed
	assert_same_set [:shelf,:lost] ,ts.transitions
	begin
		ts.transit :missing
		fail "illegal transition should cause error"
	rescue
	end

end

def assert_transtions(reached,ts)
	ts.possible_states.each{|n|
		t1 = ts.dup
		if ts.is_allowed? n then
			puts "#{t1.current_state} -> #{n}"
			t1.transit n
			if not reached.include? t1.current_state then
				reached << t1.current_state
				assert_transtions(reached,t1)
			end
		else
			begin
				t1.transit n
				fail "illegal transition should cause error"
			rescue;end

		end
	}
end

def test_transitions
	initial = ToolState.new
	reached = []

	#chech that you can reach all states, and that moving to illegal states throws an exception
	ts = initial.dup
	assert_transtions(reached,ts)

	assert_same_set initial.possible_states,reached #, "did not get to all states"
end



end


