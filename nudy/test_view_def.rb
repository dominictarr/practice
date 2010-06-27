require 'test/unit'
require 'nudy/viewer'
require 'nudy/view_def'
require 'nudy/test_viewer'
require 'monkeypatch/TestCase'

class TestViewDef < Test::Unit::TestCase
include Test::Unit

#set_types #the target types - use same method as Viewer
#set_viewer - the Viewer class to show
#set_parent - the ViewerPlan to revert to if this one does not know what to do. - 
#type_strict #turns type checking onto it's fields.
#as_field ? - doesn't create members for it's fields. - and sets not to open if it's an action.
#sets field/nested/mutable/openable?

#child_builder. (list
#parent_builder

#builder has list of ViewerPlans, or is the ViewerPlan the builder?... 
#just haveing a list of sub plans (which it assigns to it's members)

#when a viewer has a builder.
#	that represents it's own display,
#	the sub builders are it's members.

def test_types_simple
	b = ViewDef.new
	assert b.handles?(Object.new)
	assert_equal b, b.set_types(String) #have functions return self for easy chaining.
	assert !b.handles?(Object.new)
	assert b.handles?("hello")
	b.set_viewer(Viewer)
	string_viewer = b.build("hello")
	assert string_viewer
end

def make_fields (builder,viewer,names)
	names.each{|name|
		if name.is_a? String then
			f_object = viewer.object.method(name).call
			if builder.handles? f_object then
				viewer.add_members(builder.build(viewer.object).set_control(viewer,name))
			end
		elsif Array === name #must be an action
			if builder.handles? nil then
				viewer.add_members(builder.build(nil).set_control(viewer,*name))
			else
			fail "ERROR: nothing to handle: #{name.inspect}"
			end
		end
	}
end
def test_make_fields
	b = ViewDef.new
	b.viewer = Viewer
	haf = TestViewer::HasAField.new
	assert b.handles? haf
	b.auto_fields = true
	v = b.build(haf)

	#i've just decided that ViewDef won't handle the heirachical structure.
	#am I trying to plan too far ahead? maybe I should use an expedient approch, 
	#and rewrite it when I've really found the need?

	#we now have a viewer with no members...
	#we need to get what the member names and objects are.
	#... 2D array!

	ft = b.members_for(haf)
	#..this gives everything we need to build the fields.

#	ft.each{|name|
#		object = 
#		if b.handles? object then
#			v.add_members(b.build(haf).set_control(v,name))
#		end
#	}
	make_fields(b,v,ft)
	assert v.members
#	assert_same_set [["hello",String],["taguri",String]],v.members.collect {|c| [c.name,c.get.class]}
	assert_same_set [["hello",String]],v.members.collect {|c| [c.name,c.get.class]}
end
def test_type_strict
	b = ViewDef.new
	b.viewer = Viewer
	
	types = b.types = [TestViewer::HasAField,String]
	b.type_strict = true
	haf = TestViewer::HasAField.new
	assert b.handles? haf
	b.auto_fields = true
	v = b.build(haf)

	#i've just decided that ViewDef won't handle the heirachical structure.
	#am I trying to plan too far ahead? maybe I should use an expedient approch, 
	#and rewrite it when I've really found the need?

	#we now have a viewer with no members...
	#we need to get what the member names and objects are.
	#... 2D array!

	ft = b.members_for(haf)
	#..this gives everything we need to build the fields.
	ap ft
	make_fields(b,v,ft)

	assert v.members
#	assert_same_set [["hello",String],["taguri",String]],v.members.collect {|c| [c.name,c.get.class]}
	assert_same_set [["hello",String]],v.members.collect {|c| [c.name,c.get.class]}

	assert_equal types,v.member("hello").types
#	assert_equal types,v.member("taguri").types
	begin
	v.member("hello").set(14)
	fail "expected exception when try to set field to number"
	rescue; end
#	begin
#	v.member("taguri").set(45)
#	fail "expected exception when try to set field to number"
#	rescue; end
end

class HasActions < TestViewer::HasAction
	def mutate
		hello = "ASF,H,Kasd,f,asd,gfasAHF,KAJS,FHL".split(",").shuffle.join
	end
	def create
		self.dup.mutate
	end
end

def test_actions
	actions_b = ViewDef.new
	actions_b.viewer = Viewer
	actions_b.types = [HasActions,NilClass]
	actions_b.members = [[:mutate,nil, :refresh],[:action,nil, :ignore],[:create,nil,:open]]
	
	a = HasActions.new

	v = actions_b.build(a)
	ap "test_actions"
	ap actions_b.members_for(a)

	make_fields(actions_b,v,actions_b.members_for(a))

	#now, v should have the actions mutate, action, and create
	#but it's members should not.
	assert v.has_members?, "expected #{v.inspect} to has_members?"
	ap "MEMBERS"
	ap v.members

	assert v.member(:create)
	assert v.member(:mutate)
	assert v.member(:action)
#to implement the fuctionality here i will need builder?
#	create_v = v.member(:create).call
#	assert create_v.is_a?(Viewer),"expected #{create_v}.is_a? #{Viewer}"
#	mutate_v = v.member(:mutate).call
#	assert_equal v, mutate_v.is_a?(Viewer),"expected #{create_v}.is_a? #{Viewer}"
#	assert_equal nil,v.member(:action).call

end
end
