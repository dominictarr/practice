
require 'monkeypatch/module'
require 'wee'
require 'tools/wee/handler'
require 'tools/wee/table_wee'
require 'tools/table'
class StepLog
	quick_attr :ui_test, :start_time, :finish_time, :time, :clicks, :message, :name, :block, :number, :test, :clicks
	def initialize
		clicks 0
		name ""
		message ""
	end
	def start
		@start_time = Time::now
		puts "#{self}.start: #{start_time.nil?}"
		self
	end
	def finish
		if @start_time.nil? then
			raise "error, start_time(#{start_time}) is nil. #{self}.start wasn't called" 
		end
		@finish_time = Time::now
		@time = ((@finish_time - @start_time) * 1000.0).round/1000.0
		self
	end
	def unlogged
		#@start = @finished = Time::now #even though it's unlogged we might want the time anyway....
		@logged = false				
	end
	def logged?
		@logged
	end
	def expect_render_arg (block)
		raise "step{|r| ... } given block must have one argument (for render context).
instead it has #{block.arity} arguments" if block.arity != 1 or block.arity < -2
	end
	def render (r)
		start if !@started
		@started = true
		raise "#{self} (#{self.class})was not given a block" if block.nil?
		expect_render_arg block
		block.call(r)
	end
end
class UiTest2 < Wee::Component
attr_accessor :component, :steps, :intro, :debrief, :step_number,:current_log
#okay,
#test title -> (test subject) step x/X (message space correct/mistake whatever)   procede...
#then h divider
#then the test subject in the middle.

#instead of 
def initialize
	init
	super
end
def unlogged
	current_step.unlogged
end
#def message (text)
#	@current_log.message = text
#end
def finished? 
	@step_number == -1
end
def current_step
	@steps[@step_number]
end

	def children
		@children = [] if @children.nil?
		@children
	end

def step_passes
	current_step.finish
	puts "step passes"
	puts "time: #{current_step.time}"


	#log the time taken for this step.
	#count clicks.
	# how to count clicks? 
	#is there someway to add javasscript to the page which will make a callback?
	#to work well... it will need to append that message to the request.
	#cool. that means i'll get to learn how that end of it works.

	@step_number += 1
	if @step_number >= @steps.length then
		@step_number = -1
	end
end
def state (s)
	super
	@callback_counter = 0 if @callback_counter.nil?
	@callback_counter += 1
	current_step.clicks(current_step.clicks + 1)

	s.add_ivar(self, :@steps, @steps)
	s.add_ivar(self, :@step_number, @step_number)
end
def step (&block)
	@steps << s = StepLog.new
	s.ui_test(self).number(@steps.length - 1)
	s.block(block) if block #incase you find it more convienent to say title etc first.
	s
end
#def introduction (text)
#expect_render_arg
#	@render.paragraph(text)
#end

def all_steps
	#make calls to step here...
end
def defaults

	@debrief = proc {|r| r.h2("debrief")

	#	r.table {#next write a table class...
	#		r.table_row{
	#		  r.table_header "#"
	#		  r.table_header "name"
	#		  r.table_header "clicks"
	#		  r.table_header "time"
	#		}
	#	  @steps.each_index {|i|
	#		r.table_row{
	#		  r.table_data i
	#		  r.table_header @steps[i].name
	#		  r.table_data @steps[i].clicks
	#		  r.table_data @steps[i].time
	#		}}}

		tw = TableWee.new.table Table.new.tabulate(@steps).headers(:number,:name,:clicks,:time)
		r.render tw

		r.break

		overall_time = (@steps.last.finish_time - @steps.first.start_time)
		totals = TableWee.new.table Table.new.tabulate({"Time" => overall_time, 
								"Clicks" => @callback_counter}).headers("Total","Amount")
		r.render totals
	}
end
def init
   @init ? return : @init = true
   @steps = []
   @step_log = []
   @started = false
   all_steps
   @step_number = 0
   defaults #set default intro and debrief

   puts "starting User Interface Test: #{self.class}. (0/#{@steps.length})."
end
  def check_test_condition
	if current_step.test and t = current_step.test.call #if the block returns true, conditions are met. tell the test.
		step_passes
	end
  end

  def process_callbacks(callbacks)
	return_value = super
	proc {return_value ? return_value.call : nil; check_test_condition}
 end

def header (r)
	r.div {
	step_count = finished? ? @steps.length : current_step.number
	r.paragraph "test:<i>#{self.class}</i> subject:<i>#{component.class}</i> steps:<i>#{step_count}/#{@steps.length}</i>"

	}
end

def render (r)
#	@render = r
	init
	#show steps
	#r.h2 "no test steps defined for #{self.class}"
	header (r)

	if @steps.empty?
		r.h2 "Error: No test steps defined for <i>#{self.class}</i>"
	else
		! finished? ? @steps[@step_number].render(r) : @debrief.call(r)
	end
end

  def self.start_server
		Wee.runcc(eval(name), :server => :Mongrel) if __FILE__ == $0
  end
end
UiTest2.start_server if __FILE__ == $0

