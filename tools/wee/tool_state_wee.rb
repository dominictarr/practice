require 'wee'

require 'tools/wee/handler'

class ToolStateWee < Wee::Component

attr_accessor :tool_state
include HandlerMixin
def handles_class; ToolState; end
def handle (obj) @tool_state = obj; end


def state (s)
	super
#	s.add_ivar(self, :@tool_state,@tool_state)
	s.add_ivar(@tool_state, :@current,@tool_state.current_state)
end

def transit (n)
	puts "TOOL STATE: #{@tool_state.current_state} -> #{n}"
	puts Kernel.caller
	@tool_state.transit n
	
#	answer "LOST" if @tool_state.current_state == :lost
end
def link_transition (r,s)
	r.space
	r.anchor.callback_method(:transit,s).with(s)
end

def render (r)
	r.label ("(#{@tool_state.current_state}) ->")
	@tool_state.transitions.each{|s|
		link_transition(r,s)
	}	
end
end

Wee.runcc(ToolStateWee, :server => :Mongrel) if __FILE__ == $0
