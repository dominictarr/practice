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

	assert Viewable,ib.get(TestAttrMemberBuilder::ClassWithMembers)

	viewer = ib.build(c)
	assert_same_set [:a_string,:an_object,:taguri], viewer.members.collect {|c| c.name.to_sym}
	ap viewer.members 
	assert viewer.member(:an_object).viewer
	assert_same_set [:name,:taguri,:this,:age,:friends], viewer.member(:an_object).viewer.members.collect {|c| c.name.to_sym}

	assert_equal ib,viewer.builder
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
end
