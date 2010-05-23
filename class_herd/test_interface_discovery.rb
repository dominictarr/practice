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

def wrap_string(idw)
        a_klass = idw.wrap(String)
	a = a_klass.new("hello")
	a.upcase!
	assert_equal "HELLO",a
	#puts a_klass
	a_klass
end
 
def wrap_array(idw)
        a_klass = idw.wrap(Array)
        a = a_klass.new([:a,:b,:c,:d])
        assert_equal [:a,:b,:c,:d],a
        d = a.dup
        a.delete :b 
        a.delete :d
        d.delete :a
        d.delete :b
        assert_equal [:a,:c],a
        assert_equal [:c,:d],d
        d = d.reverse
	return a_klass
end

def assert_equal_idw(idw1,idw2,sym)
	m = method(sym)
	k1 = m.call(idw1)
	k2 = m.call(idw2)
	assert_equal idw1.interface(k1),idw2.interface(k2)
end

def test_self_reference
      	boots = InterfaceDiscoveryWrapper.new
	idw_klass = boots.wrap(InterfaceDiscoveryWrapper)
	idw = idw_klass.new

        assert_equal_idw(boots,idw,:wrap_string)
	puts boots.interface(idw_klass)

	wrap_array(idw)
end

def test_self_reference_double
        boots = InterfaceDiscoveryWrapper.new
        idw_klass = boots.wrap(InterfaceDiscoveryWrapper)
	idw2_klass = boots.wrap(idw_klass)
        idw = idw2_klass.new

	wrap_array(idw)
	s1 = boots.wrap(String)
	s2 = idw.wrap(s1)

	h = s2.new("hello")

	h.upcase!
	assert_equal "HELLO",h
	puts "***********"
	puts idw.interface(s2).inspect
	puts boots.interface(s2).inspect

        puts idw.interface(s1).inspect
        puts boots.interface(s1).inspect

	assert_equal_idw(boots,idw,:wrap_string)
        puts boots.interface(idw_klass)
end

def test_double_wrap

     	idw = InterfaceDiscoveryWrapper.new
        idw2 = InterfaceDiscoveryWrapper.new
 	s_klass = idw.wrap(String)
	ss_klass = idw2.wrap(s_klass)

	ss = ss_klass.new("hello")
	#puts ss_klass.instance_methods.inspect
	ss.capitalize

	assert_equal [:capitalize], idw.interface(s_klass)
	assert_equal [:capitalize], idw2.interface(ss_klass)

	#how, precisely should it behave in this situation?
	#does it matter if idw2 knows about stuff which happens to an ss_klass?
	#would need to implement stuff to handle the particular class instance which
	#IDW is wrapping... maybe it would be simpler to map from the original class instance?
end

class Hello; end
#~ def test_double_alias
#~ h = Hello.new
#~ Hello.send(:define_method, :hi){"hello"}
#~ Hello.send(:alias_method, :hi_original, :hi)
#~ Hello.send(:alias_method, :hi_old, :hi)
#~ assert_equal "hello", h.hi
#~ assert_equal "hello", h.hi_old
#~ Hello.send(:define_method, :hi){"hello_there"}
#~ assert_equal "hello_there", h.hi
#~ assert_equal "hello", h.hi_old
#~ Hello.send(:alias_method, :hi_old2, :hi)
#~ Hello.send(:define_method, :hi){"good_day"}
#~ assert_equal "good_day", h.hi
#~ assert_equal "hello_there", h.hi_old2
#~ assert_equal "hello", h.hi_old
#~ assert_equal "hello", h.hi_original

#~ ##that seems to work. what if you alias the method but dont define anything.
#~ end

#~ def test_double_alias2
#~ h = Hello.new
#~ Hello.send(:alias_method, :method_1, :method)
#~ Hello.send(:define_method, :method_1){"hello"}

#~ assert_equal "hello",h.method_1
#~ assert_equal "hello",h.method(:method_1).call
#~ end

def assert_arity (klass,wrapped)
	assert_equal (klass,wrapped)
	klass.instance_methods.each{
		|m|
		assert wrapped.instance_method(m), "#{wrapped}.#{m} not defined!"
		assert_equal klass.instance_method(m).arity, wrapped.instance_method(m).arity, "expected #{klass}.instance_method(:#{m}).arity == #{wrapped}.instance_method(:#{m}).arity."
	}
end

def test_arity
idw = InterfaceDiscoveryWrapper.new
a = [Hello,String,CodeBlockUser,TestInterfaceDiscovery,InterfaceDiscoveryWrapper]

#a.each{|m|assert_arity(m,m)}
a.each{|m|assert_arity(m,idw.wrap(m))}

end

end;end
