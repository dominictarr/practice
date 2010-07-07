
require 'tools/ui_tests/ui_test'
require 'tools/wee/user_registry_wee'
require 'tools/user_registry'

class UiTestUserRegistry < UiTest
def wants_handler_for_class
   UserRegistry
end
def initialize
	super
	@component = UserRegistryWee.new
end
  def description
	"this is a component that lets users log into the system"
  end
  def all_steps
	ur = UserRegistry.new
	w = @component
	w.handle(ur)
	step("signup as \'user\'", w) {ur.user('user') != nil}
	step("login as \'user\'", w) {ur.loggedin? session.id}
	step("logout", w) {!ur.loggedin? session.id}
	#finish
  end
end

Wee.runcc(UiTestUserRegistry, :server => :Mongrel) if __FILE__ == $0

