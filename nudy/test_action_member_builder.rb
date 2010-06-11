require 'rubygems'
require 'test/unit'
#require 'interface_builder'
require 'ap'
#require 'field'
require 'nudy/action'
#require 'object_viewer'

require 'nudy/action_member_builder'

class TestActionMemberBuilder < Test::Unit::TestCase
include Test::Unit

class ClassWithActions
	attr_accessor :name,:age,:friends,:this

	def initialize 
		@name = "billy"
		@age = 11
		@friends = ["sam","matthew","james"]
		@this = self
	end

	def unname
		@name = "noname"
	end
	def say_yes
		"yes"
	end
end

def test_simple
	c = ClassWithActions.new
	mb = ActionMemberBuilder.new(Action)

	assert mb.handles? (c,"unname")
	assert mb.handles? (c,"say_yes")

	mb = ActionMemberBuilder.new(Action,"no way")

	assert !(mb.handles? (c,"unname"))
	assert !(mb.handles? (c,"say_yes"))

	mb = ActionMemberBuilder.new(Action,"say_yes")

	assert !(mb.handles? (c,"unname"))
	assert mb.handles? (c,"say_yes")

	un = mb.build(c,:unname)
	say = mb.build(c,:say_yes)

	assert Action === un 
	assert Action === say
	assert_equal "billy",c.name
	un.call
	assert_equal "noname",c.name
	assert_equal "yes",say.call
end
def test_symbol
	c = ClassWithActions.new
	mb = ActionMemberBuilder.new(Action)

	assert mb.handles? (c,:unname)
	assert mb.handles? (c,:say_yes)

	mb = ActionMemberBuilder.new(Action,:no_way)

	assert !(mb.handles? (c,:unname))
	assert !(mb.handles? (c,:say_yes))

	mb = ActionMemberBuilder.new(Action,:say_yes)

	assert !(mb.handles? (c,:unname))
	assert mb.handles? (c,:say_yes)

	un = mb.build(c,:unname)
	say = mb.build(c,:say_yes)

	assert Action === un 
	assert Action === say
	assert_equal "billy",c.name
	un.call
	assert_equal "noname",c.name
	assert_equal "yes",say.call
end


end
