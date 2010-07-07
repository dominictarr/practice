require 'wee'
require 'tools/ui_tests/ui_test2'
require 'tools/wee/table_wee'
require 'tools/table'

class UiTest2TableWee < UiTest2
def initialize 
	super
	@component = TableWee.new
	children << @component
end
  def look_right? (table)
	step {|r|
		#tw = TableWee.new.table(table)
		@component.table table

		r.render @component
		r.break
		r.paragraph "does this look right?"
		r.break
		r.anchor.callback {step_passes} .with "No"		
		r.space
		r.anchor.callback {step_passes} .with "Yes"
	}.name("look right?")

  end
  def all_steps
	look_right? Table.new.tabulate({:a=>1,:b=>2,:c=>3}).headers(:letter,:number)
	look_right? Table.new.tabulate({:a=>1,:b=>2,:c=>3}.to_a.transpose).headers(:one,:two,:three)
  end
end

#UiTest2ToolState.start_server if __FILE__ == $0

Wee.runcc(UiTest2TableWee, :server => :Mongrel) if __FILE__ == $0 

