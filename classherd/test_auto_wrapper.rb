require 'test/unit'
require 'v_c_r'
require 'auto_wrapper'
require 'class_creator_example'

#auto wrapper
#~ when activated , wrap every object that is created with a given class

#~ ie. 

#~ autowrapper.on(klass) # sets @wrapper = klass
#~ autowraper.wrap(obj) # returns @wrapper.new(obj)
#~ autowrapper.off() #deactivates wrapping
#~ autowrapper.list # returns the objects which have been wrapped.

module ClassHerd
class ClassHerd::TestAutoWrapper < Test::Unit::TestCase

def test_wrap_on_off 
	aw = AutoWrapper.new(VCR)
	aw.on
	#now create an object, and we want AutoWrapper to wrap it!
	x = String.new("hello")
#	puts aw.list.inspect
	aw.off
	assert aw.list.include? x
	assert x.is_a?(VCR)
	assert x.wrapped.is_a?(String)

	#some non wrapped stuff to check behaviour of dup()
	
	y = String.new("goodbye")
	assert_equal false, y.is_a?(VCR)
	assert_equal (false, aw.list.include?(y))
end

#there are alot of things to test, and it's a bit boring for right now. 
#so i'll do this later.

def test_wrap_transparent
	#calling dup should copy the object, but not object's it's variables refur to.
	#however, since we don't want anything to realise that we've wrapped it
	#it should dup the wrapped object, and the wrapper.

	a = String.new("there there")
	b = a.dup
	c = a.clone

	assert_not_equal a.object_id,  b.object_id
	assert_not_equal a.object_id,  c.object_id

	aw = AutoWrapper.new(VCR)

	aw.on
	x = String.new("hello")
	y = x.dup #this is a method the wrapper needs to handle specially.
	aw.off

	assert aw.list.include? x
	assert x.is_a?(VCR)
	assert x.wrapped.is_a?(String)
	assert y.is_a?(VCR)
	assert y.wrapped.is_a?(String)
	
	assert_not_equal x.object_id,  y.object_id
	assert_not_equal x.wrapped.object_id,  y.wrapped.object_id
	


	assert_not_equal x.wrapped.object_id,  y.wrapped.object_id
	
	y = String.new("goodbye")
	assert_equal (false, aw.list.include?(y))
end

#wrap objects which the object you've wrapped create
#

def test_two_layer
	aw = AutoWrapper.new(VCR)

	aw.on
	x = ClassCreatorExample.new()
	y = x.createSomething(String, "String")
	aw.off
	assert x.is_a?(VCR)
	assert x.wrapped.is_a?(ClassCreatorExample)
	assert y.is_a?(VCR)
	assert y.wrapped.is_a?(String)
	assert_equal y.wrapped.to_s, y.to_s
	


end

def test_three_layer
	aw = AutoWrapper.new(VCR)
	aw.on
	x = ClassCreatorExample.new()
	y = x.createSomething(ClassCreatorExample)
	z = y.createSomething(String, "String")
	aw.off
	assert x.is_a?(VCR)
	assert x.wrapped.is_a?(ClassCreatorExample)
	assert y.is_a?(VCR)
	assert y.wrapped.is_a?(ClassCreatorExample)
	assert z.is_a?(VCR)
	assert z.wrapped.is_a?(String)
	assert_equal z.wrapped.to_s, z.to_s

end


end end