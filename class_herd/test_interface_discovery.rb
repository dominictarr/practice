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

	assert_equal [:capitalize!], idw.interface(sklass) 
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

class CodeBlockUser
	def call_block (&block)
		return block.call
	end 

	def save_block (&block)
		@block = block
	end
	def call_saved_block (*args, &block)
		@block.call(*args, &block)
	end
end

def assert_compatible? (idw,k1,k2,bool)

assert (idw.is_compatible?(k1,k2) == bool), "expected #{k1} to #{bool ? '' : 'not'} be compatible with #{k2}"
end

def test_block_method
	idw = InterfaceDiscoveryWrapper.new
	cbu_klass = idw.wrap(CodeBlockUser)#returns a class, which, 
	cbu = cbu_klass.new
	assert_equal "block!", CodeBlockUser.new.call_block {"block!"}, 
		"pass a block block normally"
	assert_equal "block!", cbu.call_block {"block!"}, 
		"pass a block to a wrapped class"

	assert cbu_klass.instance_methods.include?("call_block"),"expect CodeBlockUser to have method 'call_block'"

	assert_compatible?(idw,cbu_klass,cbu_klass,true)
 	assert_compatible?(idw,CodeBlockUser,cbu_klass,true)
        assert_compatible?(idw,String,cbu_klass,false)

	begin
        assert_compatible?(idw,CodeBlockUser,Integer,false)
  	assert false,"expected is_compatible? to throw an exception if you ask about a klass it doesn't wrap."
	rescue; end
	begin
      		assert_compatible?(idw,cbu_klass,CodeBlockUser,false)
        	assert false,"expected is_compatible? to throw an exception if you ask about a klass it d
oesn't wrap."
        rescue; end
  

	#cbssert_compatible?(idw,CodeBlockUser,cbu_klass,true)
        cbu.save_block {|k,v| k*v}
	assert_equal 36, cbu.call_saved_block(9,4)
end

def assert_is_a? (o,c)
	assert o.is_a?(c), "expected #{o}.is_a?(#{c}). o.class=#{o.class}"
end

def test_is_a?
        idw = InterfaceDiscoveryWrapper.new
        cbu_klass = idw.wrap(CodeBlockUser)#returns a class, which, 
        cbu = cbu_klass.new
	assert_is_a? cbu,CodeBlockUser  
	assert CodeBlockUser === cbu, "CodeBlockUser === #{cbu}"
	assert_is_a? cbu,cbu_klass
        assert cbu_klass === cbu, "#{cbu_klass} === #{cbu}"
 
	assert_is_a? CodeBlockUser.new, cbu_klass 
end

end;end
