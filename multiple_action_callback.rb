require 'rubygems'
require 'wee'
require 'tools/ui_tests/ui_test_tool_state'
require 'tools/ui_tests/ui_test'

class MultipleActionCallback < Wee::Component
def initialize (nest = true)
	super()
#ts = UiTestToolState.new
ts = ToolStateWee2.new
ts.handle (ToolState.new)
#@children = [Child1.new,Child2.new]

@children = [ts,Child2.new, ui = UiTest.new]
ui.component =(Child2.new)
@children << MultipleActionCallback.new(false) if nest

end
def children; @children end
def render(r)
	r.div {
	children.each{ |c|
	r.anchor.callback {@child = c}.with(c.class)
	r.space
	}
	}
	r.render(@child) if @child

end
end

class Child1 < Wee::Component
def render (r)
	r.label("this is child 1")
end
end
class ChildN < Wee::Component

def initialize (n = 2)
	super()
	@n = n
end

def render (r)
	r.label("this is child N=#{@n}")
	
	r.break
	r.anchor.callback {
		callcc ChildN.new(@n + 1)
		
	}.with("next child: #{@n + 1}")
	r.break
	r.anchor.callback {
		answer
	}.with("(previous)")
end
end
class Child2 < Wee::Component
def render (r)
	r.label("this is child 2 (try switching to child1)")
	r.anchor.callback {
		callcc ChildN.new(3)
	}.with("child 3")
end
end


Wee.runcc(MultipleActionCallback, :server => :Mongrel) if __FILE__ == $0
