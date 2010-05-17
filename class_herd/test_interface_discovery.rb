require 'class_herd/interface_discovery_wrapper'
require 'test/unit'

module ClassHerd
class TestInterfaceDiscovery < Test::Unit::TestCase
include Test::Unit

def test_simple
	idw = InterfaceDiscoveryWrapper.new
	sklass = idw.wrap(String)#returns a class, which, 
	#if invoked will provide information about the interface that gets used.

	s = sklass.new("hello")
	#assert s.is_a?(String), "wrapped object should appear to be same class" 
	s.capitalize!

 	assert_equal "Hello",s
	assert idw.instances(sklass).include?(s),
		"InterfaceDiscoverWrapper#instances should return list of instances"

	assert_equal [:initialize,:capitalize!], idw.interface(sklass)
 
end

def test_more_methods
        idw = InterfaceDiscoveryWrapper.new
        wArray = idw.wrap(Array)#returns a class, which, 
 	w = wArray.new([:a,:b,:c])
	a = Array.new([:a,:b,:c])
	assert_equal a,w
	#puts "#{w.inspect}"
	assert_equal a.length,w.length
	a.reverse
	w.reverse
  	assert_equal a,w
end

end;end
