

require 'wee'
require 'tools/wee/handler'
class UiTestStepLog
	attr_accessor :ui_test, :start_time, :finish_time, :time, :clicks, :message, :name
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
		@start = @finished = Time::now
		@logged = false				
	end
	def logged?
		@logged
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
def start_step
	puts "start step"
	
	@step_log << @current_log = UiTestStepLog.new.start
end
def unlogged
	@current_log .unlogged
end
def message (text)
	@current_log.message = text
end
def finished? 
	@step_number == -1
end
def step_passes
	@step_number += 1
	@current_log.finish
	if @step_number >= @steps.length then
		@step_number = -1
		@overall_log.finish
	else
		start_step
	end
	puts "step passes"
	puts "time: #{@current_log.time}"
	#log the time taken for this step.
	#count clicks.
	# how to count clicks? 
	#is there someway to add javasscript to the page which will make a callback?
	#to work well... it will need to append that message to the request.
	#cool. that means i'll get to learn how that end of it works.
end
def expect_render_arg (block)
raise "step{|r| ... } given block must have one argument (for render context).
instead it has #{block.arity} arguments" if block.arity != 1 or block.arity < -2
end

def step (name="",&block)
	expect_render_arg block
	@steps << block
	#store the blocks in the log class (which would be tidier, and better for recalling.
	#automaticially call start timer the first time a block is called... not in render.
end
def introduction (text)
#expect_render_arg
	@render.paragraph(text)
end

def all_steps
	#make calls to step here...
end
def defaults
#	@intro = proc {|r| r.h2("intro")}
	@debrief = proc {|r| r.h2("debrief")
		#r.render TableWee.new(@step_log,:time)
		r.table {
			r.table_row{
			  r.table_header "#"
			  r.table_header "time"
			}
		  @step_log.each_index {|i|
			r.table_row{
			  r.table_data i
			  r.table_data @step_log[i].time
			}}}

		r.div {
			r.paragraph {
				r.encode_text "time overall: #{@overall_log.time}"
			}}}
end
def init
   @init ? return : @init = true
   @steps = []
   @step_log = []
   @started = false
   @overall_log = UiTestStepLog.new
   all_steps
   @step_number = 0
   defaults #set default intro and debrief

   puts "starting User Interface Test: #{self.class}. (0/#{@steps.length})."
end

def render (r)
	@render = r
	init
	#show steps
	#r.h2 "no test steps defined for #{self.class}"
	if @steps.empty?
		r.h2 "Error: No test steps defined for <i>#{self.class}</i>"
	else
		if ! @started then
			@overall_log.start
			start_step 
			@started = true
		end
		if @step_number != -1 then
			@steps[@step_number].call(r) 
		elsif @step_number == -1 then
			@debrief.call(r)

		end
	end
end

  def self.start_server
		Wee.runcc(eval(name), :server => :Mongrel) if __FILE__ == $0
  end
end
UiTest2.start_server if __FILE__ == $0

