require 'wee'
require 'tools/wee/tool_state_wee2'
require 'tools/ui_tests/ui_test'

class UiTestToolState < UiTest
def wants_handler_for_class
   ToolState
end
def initialize 
	super
	@component = ToolStateWee2.new
	@component.handle (ToolState.new)
end
  def put_tool_into_state (state,tsw)
#	instruction "try to change the tool state to \"#{state}\""
#	test(tsw){tsw.tool_state.current_state == state}
	inst = "change the item to \"#{state}\""
	step(inst,tsw){tsw.tool_state.current_state == state}
  end
  def description
"following is a component for recording the location of a library item.<br>
It could be books, but it could be a library for other sorts of objects too.<br>"
  end
  def all_steps
	tsw = @component
	put_tool_into_state (:borrowed,tsw)
	put_tool_into_state (:lost,tsw)
	put_tool_into_state (:in_use,tsw)
	put_tool_into_state (:shelf,tsw)
	#finish
  end
end


Wee.runcc(UiTestToolState, :server => :Mongrel) if __FILE__ == $0

