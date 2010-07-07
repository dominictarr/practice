require 'rubygems'
require 'tools/wee/handler'
require 'tools/ui_tests/ui_test'


class CoupleUiTests
require 'tools/ui_tests/ui_test_array_link'
require 'tools/ui_tests/ui_test_tool_state'
require 'tools/ui_tests/ui_test_user_registry'

require 'tools/wee/array_link_wee'
require 'tools/wee/tool_state_wee'
require 'tools/wee/tool_state_wee2'
require 'tools/wee/user_registry_wee'
require 'tools/wee/couple_ui_tests_wee'

def check_mixin_interface(o,m)
! m.instance_methods.find {|e|
	#puts "#{e}(#{m.instance_method(e).arity})"
	!(o.instance_methods.include? e and m.instance_method(e).arity == o.instance_method(e).arity)
}

end
def check_is_handler(o)
	check_mixin_interface(o,HandlerMixin)
end
def check_wants_handler(o)
	check_mixin_interface(o,TestsHandlerMixin)
end
def all_implements(klass,method)
	all = []
	ObjectSpace.each_object(Class) {|o|
		if o <= klass and method.call(o) then #	and check_is_handler(o) then
		  all << o
		end
	}
	all
end
def all_ui_tests
	all_implements(UiTest,method(:check_wants_handler))
end
def all_components
	all_implements(Wee::Component,method(:check_is_handler))
end

def coupled_tests
	coupled_tests = []
	tests = all_ui_tests.map {|m| m.new}
	components = all_components.map{|m| m.new}
	tests.each {|test|
	   components.select {|f| 
		f.handles_class?(test.wants_handler_for_class)
	   }.each {|handler|
	   coupled_tests << c = test.class.new
	   c.component = handler.class.new
	   }
	}

end
end


if __FILE__ == $0 then
#puts HandlerMixin.instance_methods
#HandlerMixin.instance_methods.each{|e|
#	puts "#{e}(#{HandlerMixin.instance_method(e).arity})"
#}
  r = CoupleUiTests.new
  puts "UiTests:"
  puts r.all_ui_tests
  puts "Testable Components:"
  puts r.all_components
  puts "Tests:"
  r.coupled_tests.each{|t|
	puts "#{t.class}->#{t.component.class}"
  }
end
