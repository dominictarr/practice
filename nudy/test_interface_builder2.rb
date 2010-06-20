require 'test/unit'
require 'monkeypatch/TestCase'

#require 'nudy/interface_builder2'
require 'nudy/viewable'


require 'nudy/reference'
require 'nudy/options'

require 'nudy/options_member_builder'
require 'nudy/test_attr_member_builder'
require 'nudy/test_action_member_builder'

class TestInterfaceBuilder2 < Test::Unit::TestCase 
include Test::Unit

def test_simple
	c =  TestAttrMemberBuilder::ClassWithMembers.new

	ib = InterfaceBuilder2.new.add(AttrMemberBuilder.new(Field),ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(TestAttrMemberBuilder::ClassWithMembers,Viewable)

	assert Viewable,ib.get(TestAttrMemberBuilder::ClassWithMembers)

	viewer = ib.build(c)
	assert_same_set [:name,:taguri,:this,:age,:friends], viewer.members.collect {|c| c.name.to_sym}

	assert_equal ib,viewer.builder
end

def test_actions
		klass = TestActionMemberBuilder::ClassWithActions
	c =  klass.new

	ib = InterfaceBuilder2.new.add(AttrMemberBuilder.new(Field),ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(klass,Viewable)

	assert Viewable,ib.get(klass)

	viewer = ib.build(c)
	assert_same_set [:name,:taguri,:this,:age,:friends,:unname,:say_yes], viewer.members.collect {|c| c.name.to_sym}

	assert_equal ib,viewer.builder
end

def test_masked
	c =  TestAttrMemberBuilder::ClassWithMembers.new

	ib = InterfaceBuilder2.new
	ib = InterfaceBuilder2.new.add(AttrMemberBuilder.new(Field),ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(TestAttrMemberBuilder::ClassWithMembers,Viewable).mask=[:taguri,:this,:friends]
#	cwm.names = [:name,:age]
#	cwm.member_builders << AttrMemberBuilder.new(Field)

	assert Viewable,ib.get(TestAttrMemberBuilder::ClassWithMembers)

	viewer = ib.build(c)
	assert_same_set [:name,:age], viewer.members.collect {|c| c.name.to_sym}

	assert_equal ib,viewer.builder
end

def test_revert
#revert to a parent builder if you don't have a mapping.


	revert = InterfaceBuilder2.new
	revert.add(AttrMemberBuilder.new(Field),ActionMemberBuilder.new(Action,:methods,:clone))
	revert.map(Object,Viewable).mask << :taguri

	c =  TestAttrMemberBuilder::ClassWithMembers.new

	assert revert
	ib = InterfaceBuilder2.new(revert)
	assert_equal revert,ib.parent
	
	ib.add(AttrMemberBuilder.new(Field),ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(TestAttrMemberBuilder::ClassWithMembers,Viewable)

	assert_equal revert,ib.parent
	assert Viewable,ib.get(TestAttrMemberBuilder::ClassWithMembers)
	assert Viewable,ib.get(Object)

	viewer = ib.build(o = Object.new)
	assert viewer
	ap viewer.members
	assert_same_set [:methods,:clone], viewer.members.collect {|c| c.name.to_sym}

	assert_equal o.methods, viewer.member(:methods).call

	assert_equal ib, viewer.builder
end
class WithReference
	attr_accessor :a_string,:an_object

	def initialize 
		@a_string = "hello"
		@an_object = TestAttrMemberBuilder::ClassWithMembers.new
	end
end

def test_sub_viewer
	klass = TestAttrMemberBuilder::ClassWithMembers
	c =  WithReference.new

	
	ib = InterfaceBuilder2.new
	r = AttrMemberBuilder.new(Reference,klass)
	assert_equal r,r.set_builder(ib)
	ib.add(	r,
		f = AttrMemberBuilder.new(Field),
		a = ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(Object,Viewable)

	assert_equal Viewable,ib.get(TestAttrMemberBuilder::ClassWithMembers).viewer

	viewer = ib.build(c)
	assert_same_set [:a_string,:an_object,:taguri], viewer.members.collect {|c| c.name.to_sym}
	ap viewer.members 
	assert viewer.member(:an_object).viewer
	assert_same_set [:name,:taguri,:this,:age,:friends], viewer.member(:an_object).viewer.members.collect {|c| c.name.to_sym}

	assert_equal ib,viewer.builder
end

def test_sub_viewer_error
	klass = TestAttrMemberBuilder::ClassWithMembers
	c =  WithReference.new

	
	ib = InterfaceBuilder2.new
	r = AttrMemberBuilder.new(Reference)
	assert_equal r,r.set_builder(ib)

	ib.add(r)
	ib.map(Object,Viewable)
	viewer = ib.build(c)
	#the 
	puts "MEMBERS"
	puts viewer.members.collect {|c| c.name}
	assert viewer.member(:an_object)
	assert viewer.member(:an_object).viewer
	assert viewer.member(:a_string)
	assert viewer.member(:a_string).viewer
end


class WithOptions
	attr_accessor :a_string,:an_object,:option
	def options
		[:option1,:option2,:option3]
	end
	def initialize 
		@a_string = "goodbye"
		@an_object = WithReference.new
		@option = nil
	end
end

def test_options
	ib = InterfaceBuilder2.new
	klass = TestAttrMemberBuilder::ClassWithMembers
	ib.add(	o = OptionsMemberBuilder.new(Options).set_builder(ib),
		r = AttrMemberBuilder.new(Reference,klass).set_builder(ib),
		f = AttrMemberBuilder.new(Field),
		a = ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(Object,Viewable)	

	c =  WithOptions.new
	viewer = ib.build(c)
	assert (viewer.member(:option).is_a? Options), "expected #{viewer.member(:option)}.is_a? #{Options}"
	assert c.options
	assert viewer.member(:option).parent
	assert_equal c.options,viewer.member(:option).options
end

#test the sort of stuff you might do to a webpage. /
#like check and set any object. /
#open a referenced object for viewing and editing. /
#assign a reference to a another object.
#select an option 
#try to select an illegal option.
#view an array.
#set a field in an array member.
#try to open a nil object
#assign a field which is currently nil
#assign nil to a field.
#assign a reference to a new object.
def setup_for_all

	ib = InterfaceBuilder2.new
	ib.add(	o = OptionsMemberBuilder.new(Options).set_builder(ib),
		r = AttrMemberBuilder.new(Reference,WithOptions,WithReference).set_builder(ib),
		#it will only create a reference object when it's one of these items.^^
		#really, I want a reference nearly always.
		f = AttrMemberBuilder.new(Field),
		a = ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(Object,Viewable)	

	c =  WithOptions.new
	viewer = ib.build(c)
end

def test_with_options (viewer)
	assert_same_set %w{an_object a_string option taguri}, viewer.members.collect {|c| c.name}
	viewer.member(:an_object).set(WithReference.new)
	viewer.member(:a_string).set("asdhkasdgljkasdgkl")
	assert_same_set [:option1,:option2,:option3], viewer.member(:option).options
	begin
		viewer.member(:option).strict=true
		viewer.member(:option).set(:option_x)
		fail "expected #{Options} to raise error if it's set to something other than the allowed options when strict is true"
	rescue;	end

	viewer.member(:option).strict=false
	viewer.member(:option).set(:option_x)

end

def test_all

	viewer = setup_for_all
		test_with_options(viewer)

	viewer2 = viewer.member(:an_object).viewer
	assert_same_set %w{an_object a_string taguri}, 
		viewer2.members.collect {|c| c.name}


#	test_with_options(viewer2)

	viewer.member(:an_object).set(WithOptions.new) #assign a new object.
	viewer2 = viewer.member(:an_object).viewer 
	test_with_options(viewer2)#retrive the viewer for the assigned object

	viewer3 = viewer.member(:an_object).viewer
	test_with_options(viewer3)#retrive the viewer 

	viewer3.member(:an_object).set(nil)
	assert viewer_nil = viewer3.member(:an_object).viewer
	assert  viewer_nil.members

	viewer3.member(:an_object).set(["hello","hey","hi","houdy"])
	assert viewer_array = viewer3.member(:an_object).viewer
	puts "ARRAY VIEWER"
	ap viewer_array.members #this only shows taguri.

#assert_same_set %w{an_object a_string option taguri}, viewer2.members.collect {|c| c.name}



end

end
