require 'test/unit'
require 'nudy/viewer'
class TestViewer < Test::Unit::TestCase 
include Test::Unit

class HasAField
attr_accessor :hello
def initialize
	@hello = "hello"
end
end

def test_is_field
	viewer1 = Viewer.new(haf = HasAField.new)
	assert !viewer1.is_field?

	assert !viewer1.has_members?
	viewer1.add_members(field1 = Viewer.new(haf.hello).set_control(viewer1,:hello))
	assert viewer1.has_members?
	assert_equal [field1], viewer1.members
	assert_equal haf, viewer1.object

	assert field1.is_field?

	assert_equal "hello",field1.get
	field1.set("hi")

	assert_equal "hi",field1.get

	assert viewer1.is_mutable?
	assert field1.is_mutable?

	#get and set should throw an exception when it's not a field

	assert !viewer1.is_field?
	begin
		viewer1.get
		fail "expected #{viewer1} to throw exception, because !.is_field? and called .get"
	rescue; end
	assert !field1.has_members?
	begin
		field1.members
		fail "expected #{field1} to throw exception, because !.has_members? and called .members"
	rescue; end
end

def test_types
	viewer1 = Viewer.new(haf = HasAField.new)
	viewer1.add_members(field1 = Viewer.new(haf.hello).set_control(viewer1,:hello))

	field1.types=[String]
	assert_equal [String],field1.types

	field1.set("houdy")
	assert field1.is_typed?
	assert field1.is_type("houdy")
	assert !field1.is_type(36)
	begin
		field1.set(42)
		fail "#{field1}.is_typed? == #{field1.is_typed?} as #{field1.types.inspect} should not allow set(42)"
	rescue; end			

	#can also use a Proc to define the type.
	#for example, allow only odd numbers.

	field1.types=[proc {|object| object.is_a? Integer and object % 2 == 0}]
	assert field1.is_type(36)
	assert !field1.is_type(37)
end

class HasAction < HasAField
	def action
		@hello.capitalize!
	end
end

#test nested object.
def test_action
	viewer1 = Viewer.new(haf = HasAction.new)
	viewer1.add_members(field1 = Viewer.new(haf.hello).set_control(viewer1,:hello))
	viewer1.add_members(action1 = Viewer.new(nil).set_control(viewer1,:action,nil,:refresh))

	assert viewer1.has_members?
	assert field1.is_field?
	assert !field1.has_members?
	assert action1.is_action?
	assert !action1.is_field?

	action1.call
end



end
