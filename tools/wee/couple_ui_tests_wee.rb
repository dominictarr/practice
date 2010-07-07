require 'rubygems'
require 'wee'
require 'tools/couple_ui_tests'
require 'tools/wee/handler'
require 'tools/wee/array_link_wee'

class CoupleUiTestsWee < Wee::Component
include HandlerMixin
def handles_class; CoupleUiTests; end

def initialize
	super
	@handling = CoupleUiTests.new
	@menu = ArrayLinkWee.new #here is we we will need handler builders/factories/injectors
	#begin
	@init = true
	puts 
	#@menu.handle(@handling.coupled_tests)
	#rescue Exception => e
	#	puts e
	#	puts e.backtrace

	#end
	@menu.handle([1,2,3,4,5])
	@menu.callback {|c| @current = c}
	@current = nil
end
def children; 
	@current ? [@menu,@current] : [@menu]
end
#component for running tests.
#has list of tests... click on one, and it callcc's that tests.

def render (r)
	if @init then
		@menu.handle(@handling.coupled_tests)
		@init = false
	end
	r.div.style ("float:top;").with {
		r.render(@menu)
	}
	r.div {
		r.render(@current)
	} if @current
end
end

Wee.runcc(CoupleUiTestsWee, :server => :Mongrel) if __FILE__ == $0

