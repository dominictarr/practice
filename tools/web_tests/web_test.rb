require 'rubygems'
require 'wee'
require 'tools/tool_box'
require 'tools/ui_tests/ui_test_tool_state'
require 'firewatir'
require 'test/unit'

class WeeWebTestCase < Test::Unit::TestCase
include Test::Unit

def setup
	@port = 7357
	@thread  = Thread.new {
	Wee.run(UiTestToolState,:server => :Mongrel, :port => @port,:print_message => true)
	}
#	@thread.run
	sleep  1
	@browser = Watir::Browser.new
end

def test_simple
	@browser.goto("localhost:#{@port}")
	assert @thread.alive?
	assert (!@browser.text.include?"Firefox can\'t establish a connection to the server at localhost:#{@port}"), "could not find server"
	puts @browser.text
	assert @browser.text != ""
end

def test_test

end

def teardown
	@thread.kill
	@browser.close
end
end
