require 'wee'
require 'tools/ui_tests/ui_test2'
require 'tools/wee/counter'

class UiTest2Counter < UiTest2
def initialize 
	super
	@component = Counter.new
	children << @component
end
  def take_counter_to (i)
	title = "take counter to #{i}"
	step {|r|
		r.paragraph title
		r.render @component
	}.test {@component.value == i}.name (title)

  end
  def all_steps
	take_counter_to 7
	take_counter_to -3

  end
end

#UiTest2ToolState.start_server if __FILE__ == $0

Wee.runcc(UiTest2Counter, :server => :Mongrel) if __FILE__ == $0 

