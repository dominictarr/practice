require 'test/unit'
require 'nudy/array_viewer'
require 'nudy/test_viewer'
require 'ap'

class TestArrayViewer < TestViewer
include Test::Unit


class HasAnArray < HasAField
attr_accessor :list
def initialize
	super
	@list = [0,1,2,3,4,5]
end
end


def test_nested_array

	viewer1 = Viewer.new(haa = HasAnArray.new)
	assert !viewer1.is_field?
	assert !viewer1.has_members?
	viewer1.add_members(array1 = ArrayViewer.new(haa.list).set_control(viewer1,:list))
	assert array1.is_field?
	assert viewer1.has_members?
	
	assert !array1.has_members?
	a = array1.get
	a.each_index{|i| array1.add_members(Viewer.new(haa.list[i]).set_control(array1,i))} #add viewers for each member.
	assert array1.has_members?

	#test get and set.
	#ap array1.object

	(0..5).each{|i|	assert_equal i,array1.member(i).get}

	#set
	(0..5).each{|i|	
		array1.member(i).set(5 - i)
		assert_equal 5 - i,array1.member(i).get
	}
	assert_equal [5,4,3,2,1,0],array1.get

	(0..5).each{|i|	
		assert array1.member(i).is_field?
		assert array1.member(i).is_mutable?
		assert !array1.member(i).has_members?
		assert !array1.member(i).is_typed?
	}
end

#test insert and remove
#that will depend on a builder...
end
