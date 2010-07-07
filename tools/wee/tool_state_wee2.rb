require 'wee'

require 'tools/tool_state'
require 'tools/wee/handler'

class ToolStateWee2 < Wee::Component

attr_accessor :tool_state
include HandlerMixin
def handles_class; ToolState; end
def handle (obj) @tool_state = obj; end

def state (s)
	super
	s.add_ivar(@tool_state, :@current,@tool_state.current_state)
end

def transit (n)
	@tool_state.transit n
end
def link_transition (r,s)
	r.space
	r.anchor.callback_method(:transit,s).with(s)
end
def render (r)
	r.label ("item is at <i>#{@tool_state.current_state}</i> (change to ")
	@tool_state.transitions.each{|s|
		link_transition(r,s)
		r.encode_text(", ")
	}	
		r.encode_text(")")

end
end
Wee.runcc(ToolStateWee, :server => :Mongrel) if __FILE__ == $0

