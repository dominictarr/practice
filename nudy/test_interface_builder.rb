require 'test/unit'
require 'ap'

require 'nudy/interface_builder'
require 'nudy/field'
require 'nudy/action'
require 'nudy/object_viewer'

class TestInterfaceBuilder < Test::Unit::TestCase
include Test::Unit
class TwoField
	attr_accessor :one,:two
	def initialize (o = 1,t = 2)
		@one = o
		@two = t
	end
	def add
		@one + @two
	end
end
def test_simple
	ib = InterfaceBuilder.new
	ib.add(ObjectViewer,TwoField).add_fields(:one,:two)
	ib.add(Field,Fixnum)

	#ap ib.plans
	#ap ib.plans[TwoField]
	assert ib.plans[TwoField]
	tfv = ib.build(tf = TwoField.new)
	assert_equal [:one,:two], tfv.fields.collect{|e| e.name}
	one = tfv.fields[0]
	two = tfv.fields[1]
	one.set(100)
	two.set(200)
	assert_equal 100,tf.one
	assert_equal 200,tf.two
end
def test_simple2
	ib = InterfaceBuilder.new
	ib.add(ObjectViewer,TwoField).add_fields(:one,:two)
	ib.add(Field,Fixnum,Float)

	assert ib.plans[TwoField]
	tfv = ib.build(tf = TwoField.new(123.412,999.9))
	assert_equal [:one,:two], tfv.fields.collect{|e| e.name}

	one = tfv.fields[0]
	two = tfv.fields[1]
	one.set(1.1)
	two.set(2.2)
	assert_equal 1.1,tf.one
	assert_equal 2.2,tf.two
end
def test_two_layer #... test a builder which uses subtests.
	defaults = InterfaceBuilder.new
	defaults.add(Field,Fixnum,Float,Integer,String,TrueClass,FalseClass)

	assert defaults.plans[Float]

	ib = InterfaceBuilder.new(defaults)
	ib.add(ObjectViewer,TwoField).add_fields(:one,:two)

	#ap ib.plans
	#ap ib.plans[TwoField]
	assert ib.plans[TwoField]
	tfv = ib.build(tf = TwoField.new(123.412,999.9))

	assert_equal [:one,:two], tfv.fields.collect{|e| e.name}

	one = tfv.fields[0]
	two = tfv.fields[1]
	one.set(1.1)
	two.set(2.2)
	assert_equal 1.1,tf.one
	assert_equal 2.2,tf.two
end
def test_action
	ib = InterfaceBuilder.new
	ib.add(ObjectViewer,TwoField).add_fields(:one,:two).add_actions(:add)
	ib.add(Field,Fixnum)

	assert ib.plans[TwoField]
	tfv = ib.build(tf = TwoField.new)
	assert_equal [:one,:two], tfv.fields.collect{|e| e.name}
	add = tfv.actions[0]
	assert_equal 3,add.call
	one = tfv.fields[0]
	two = tfv.fields[1]
	one.set(100)
	two.set(200)
	assert_equal 300,add.call
	assert_equal 100,tf.one
	assert_equal 200,tf.two

end
end
