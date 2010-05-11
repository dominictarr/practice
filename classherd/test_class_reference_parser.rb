require 'test/unit'
require 'class_reference_parser'

module ClassHerd
class TestClassReferenceParser < Test::Unit::TestCase


def test_simple
	cr = ClassReferenceParser.new [:class, [:const, :A], nil, 
							[:const, :String], 
							[:const, :Integer]
						]
	assert_equal [:A], cr.name
	assert_equal nil, cr.super_class 
	assert_equal [[:String],[:Integer]], cr.reffs
	
	assert_equal "[class: A < {
	references:String,Integer}]",cr.inspect
end

def test_simple2
	cr = ClassReferenceParser.new [:class, [:const, :A, :B], [:const, :X] ,
							[:const, :String], 
							[:const, :Math, :Integer],
							[:class, [:const, :Strings], [:const, :String],
								[:const, :Array]
						]]
	assert_equal [:A, :B], cr.name
	assert_equal [:X], cr.super_class 
	assert_equal [[:String],[:Math,:Integer]], cr.reffs
	assert cr.innerclasses
	ss = cr.innerclasses.first

	assert_equal [:Strings], ss.name
	assert_equal [:String], ss.super_class 
	assert_equal [[:Array]], ss.reffs

	assert_equal "[class: A::B < X{
	innerclasses:[class: Strings < String{
	references:Array}]
	references:String,Math::Integer}]", cr.inspect
	
	assert_equal "[class: Strings < String{
	references:Array}]",ss.inspect
end

def test_multiple_ref #same as simple2, but with more than one ldentical reference. ClassReferences should ignore repeat references...
	cr = ClassReferenceParser.new [:class, [:const, :A, :B], [:const, :X] ,
							[:const, :String], 
							[:const, :Math, :Integer],
								[:const, :Math, :Integer],
								[:const, :String], 
								[:const, :Math, :Integer],
							[:class, [:const, :Strings], [:const, :String],
								[:const, :Array],[:const, :Array]
						]]
	assert_equal [:A, :B], cr.name
	assert_equal [:X], cr.super_class 
	assert_equal [[:String],[:Math,:Integer]], cr.reffs
	assert cr.innerclasses
	ss = cr.innerclasses.first

	assert_equal [:Strings], ss.name
	assert_equal [:String], ss.super_class 
	assert_equal [[:Array]], ss.reffs

	assert_equal "[class: A::B < X{
	innerclasses:[class: Strings < String{
	references:Array}]
	references:String,Math::Integer}]", cr.inspect
	
	assert_equal "[class: Strings < String{
	references:Array}]",ss.inspect
end
def test_innerclasses
	cr = ClassReferenceParser.new  [
		:class, [:const, :Hello1], nil,
		[:class, [:const, :Bonjour1], [:const, :Hello1]], [:class, [:const, :TestClassSub], [:const, :Test, :Unit, :TestCase], [:const, :ClassSub], [:const, :Hello1], [:const, :Bonjour1], [:const, :Hello1], [:const, :ClassSub], [:const, :Bonjour1], [:const, :Hello1], [:const, :Bonjour1]]]

	

end;end