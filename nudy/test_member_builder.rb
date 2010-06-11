require 'rubygems'
require 'test/unit'
#require 'interface_builder'
require 'ap'
require 'nudy/field'
#require 'action'
#require 'object_viewer'

require 'attr_member_builder'


class TestAttrMemberBuilder < Test::Unit::TestCase
include Test::Unit

class ClassWithMembers
	attr_accessor :name,:age,:friends,:this

	def initialize 
		@name = "billy"
		@age = 11
		@friends = ["sam","matthew","james"]
		@this = self
	end
end

def test_simple
	c = ClassWithMembers.new
	mb = AttrMemberBuilder.new(Field,String,Integer)
	assert mb.handles?(c,:name)
	assert mb.handles?(c,:age)
	assert !(mb.handles?(c,:friends))

	f1 = mb.build(c,:name)
	f2 = mb.build(c,:age)

	f1.set("bob")
	assert_equal "bob",c.name
	assert_equal f1.get,c.name

	f1.set(13)
	assert_equal 13,c.name
	assert_equal f1.get,c.name
end
def test_simple_type
	c = ClassWithMembers.new
	mb = AttrMemberBuilder.new(Field,String,Array)
	assert mb.handles?(c,:name)
	assert !(mb.handles?(c,:age))
	assert mb.handles?(c,:friends)
	assert !(mb.handles?(c,:this))
end

def test_reference_type
	c = ClassWithMembers.new
	mb = AttrMemberBuilder.new(Field)
	assert mb.handles?(c,:name)
	assert mb.handles?(c,:age)
	assert mb.handles?(c,:friends)
	assert mb.handles?(c,:this)

	c.this = nil	
	assert !(c.this) 
	#of course, nil is an object.
	assert mb.handles?(c,:this)
end
end
