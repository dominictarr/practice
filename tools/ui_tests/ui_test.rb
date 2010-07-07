require 'wee'
require 'tools/wee/handler'

class UiTest < Wee::Component
  include TestsHandlerMixin
def wants_handler_for_class
   NilClass
end
  def name
	"#{self.class}->#{component.class}"
  end
  def initialize
	@test_number = 0
	@test_number = 0
	@renderer = nil
	@prompt_next = true
  end
  def prompt_next (n=true)
	@prompt_next = n
  end
  def instruction_style
"width:400;
margin-left: auto;
margin-right: auto;
margin-top:100;
font-size:20;
text-align: center;"
  end
  def instruction(text)
	@test_number = @test_number + 1
	puts "instruction #{@test_number}: #{text}"
	callcc TestInstruction.new(text,instruction_style) 
  end

  def state (s)
	super
	s.add_ivar(self, :@test_number, @test_number)
  end
  def description
"this is the very first Meta-Modular user interface test. <br><br>
this is a test of how intuitive user interfaces are.<br><br>
It will step through a few opperations with various user interface modules.
read the instructions and then try use the interface.<br><br>
click here to continue."
  end
  def all_steps

  end
  def test (component, &block)
	TestDecoration.new(component, &block)
	callcc component
  end
  def step (text,component,&test_block)
	@test_number = @test_number + 1
	ts = TestStep.new(text,component,&test_block) 
	ts.prompt_next(@prompt_next)
	callcc ts
	#actually, this is a case where it will be better to not use continuations.
	#still use a linear interface... but load each step and then present them one at a time.
  end

  def render (r)
	puts "RENDER:"

	@renderer = r
	#for some reason, you can't come straight out with a callcc... 
	#you can't do it during render(r)
	#you have to call callcc in the action phase... which is after/before rendering? 
	unless @test_finished 
	  r.div.style(instruction_style).with{
	    r.anchor.callback{
		all_steps
		@test_finished = true
	    }.with(description)
	  }
	else
		r.div("Test Completed")
		r.anchor.callback {@test_finished = false}.with ("repeat test")
	end
  end
end

require 'wee/decoration'
class TestDecoration < Wee::Decoration

  def notify (&block)
    @notify = block
  end
  def initialize (component,&block)
	@component = component
	component.add_decoration(self)
	@test_block = block
	@notify ||= proc {raise Wee::AnswerDecoration::Answer.new([])}
  end
	
  def state (s)
	super
  end

  def check_test_condition
	if t = @test_block.call #if the block returns true, conditions are met. tell the test.
		@notify.call
	end
  end

  def process_callbacks(callbacks)
	return_value = @next.process_callbacks(callbacks)
	proc {return_value ? return_value.call : nil; check_test_condition}
 end
end

class TestStep < Wee::Component

def initialize (text,component,&test_block) 
	@component = component
	@test_block = test_block
	@done = false
	@prompt_next = true
	@notify = proc {@done = true
		if !@prompt_next then
		  answer
		end
	}
	@text = text
end

def children
	[@component]
end
def test (&block)
end
  def prompt_next (n=true)
	@prompt_next = n
  end

def wrapper_div(r)
	r.div.style("width:400;
margin-left: auto;
margin-right: auto;
margin-top:100;
font-size:14;
text-align: center;
")
end

def render(r)
		wrapper_div(r).with {
		if !@done then
		  r.div.with(@text)
		else
		  r.div.with {
		    r.encode_text("correct!")
		    r.break
		  }
		end

		r.break
		r.div.style("border:solid;").with do
		  r.render(@component)
		end

		if @done then
		  r.break
		  r.anchor.callback {answer}.with("next step")
		end
	}
end
  def process_callbacks(callbacks)
#	return_value = @next.process_callbacks(callbacks)
	return_value = super
	proc {return_value ? return_value.call : nil; check_test_condition}
 end
  def check_test_condition
	if t = @test_block.call #if the block returns true, conditions are met. tell the test.
		@notify.call
	end
  end
end

