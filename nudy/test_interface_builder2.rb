
require 'test/unit'
require 'monkeypatch/TestCase'

require 'nudy/interface_builder2'
require 'nudy/viewable'

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
end

def test_actions
		klass = TestActionMemberBuilder::ClassWithActions
	c =  klass.new

	ib = InterfaceBuilder2.new.add(AttrMemberBuilder.new(Field),ActionMemberBuilder.new(Action,:unname,:say_yes))
	ib.map(klass,Viewable)

	assert Viewable,ib.get(klass)

	viewer = ib.build(c)
	assert_same_set [:name,:taguri,:this,:age,:friends,:unname,:say_yes], viewer.members.collect {|c| c.name.to_sym}

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

	viewer = ib.build(Object.new)
	assert viewer
	ap viewer.members
	assert_same_set [:methods,:clone], viewer.members.collect {|c| c.name.to_sym}

end


end
