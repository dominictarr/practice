class ToolState

def initialize
	@current = :shelf
	@all_transitions = {
		:shelf => [:misplaced,:borrowed,:in_use],
		:borrowed => [:shelf, :lost],
		:misplaced => [:lost, :shelf],
		:lost => [:shelf],
		:in_use => [:shelf, :borrowed, :misplaced]
	}
end
def possible_states 
	[:shelf,:in_use,:borrowed,:misplaced,:lost]
end
def all_transitions
	@all_transitions
end
def current_state; @current;end

def transitions
	all_transitions[@current]
end
def is_allowed? n
 transitions.include? n
end
def transit (n)
	raise "illegal transtition (#{@current} -> #{new})" if not is_allowed? n
	@current = n
end
end
