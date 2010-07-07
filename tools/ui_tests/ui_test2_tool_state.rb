require 'wee'
require 'tools/wee/tool_state_wee2'
require 'tools/ui_tests/ui_test2'

class UiTest2Test < UiTest2
def initialize 
	super
end
  def all_steps
	step {|r|
		r.div {
		r.paragraph "hello, this is a test step for #{self.class}"
		r.break
		r.anchor.callback {step_passes}.with "go to next step..."
		}
	}
  end
end

#UiTest2ToolState.start_server if __FILE__ == $0

Wee.runcc(UiTest2ToolState, :server => :Mongrel) if __FILE__ == $0 

