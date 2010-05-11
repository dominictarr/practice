require 'x_parse'
require 'y_parse'
require 'z_parse'
require 'test/unit'

module ClassHerd
class TestXParse < Test::Unit::TestCase
include Test::Unit

const_set(:XParse, ZParse)

def test_gather_special1
	data = [:top, :x, :y, [:special, "hello"]]
	schema = [[:top, :special]]
	expected = [[:top, [:special, "hello"] ]]
	assert_equal expected, 
	XParse.new(schema).parse(data)
end

def test_flatten_xy
	data = [:top, :x, :y, 
			[:special, :x, :x], :y, 
			[:special, :x, [:top , :y]]]
	schema = [[:top, :x, :y]]
	expected = [[:top, :x,:y,:x,:x,:y,:x,:y]]
	assert_equal expected, 
	XParse.new(schema).parse(data)
end

def test_flatlist
	data = [:top, :x, :y, 
			[:special, :x, :x], :y, 
			[:special, :x, [:top , :y]]]
	schema = [:x, :y]
	expected = [:x,:y,:x,:x,:y,:x,:y]
	assert_equal expected, 
	XParse.new(schema).parse(data)
end

def test_flatten_xy2
	data = [:top, :x, :y, 
			[:special, :x, :x], :y, 
			[:special, :x, [:top , :y]]]
	schema = [ :x, :y]
	expected = [ :x,:y,:x,:x,:y,:x,:y]
	assert_equal expected, 
	XParse.new(schema).parse(data)
end

def test_gather_special2
	data = [:top, :x, :y, [:special, "hello"] , 
			[:normal, :x, :y, [:special, "goodbye"]], :x, :y]
	data = [:top, :x, :y, [:special, "hello"] , 
			:x, :y, [:special, "goodbye"], :x, :y]
	schema = [[:top, :special]]
	expected = [[:top, [:special, "hello"] , [:special, "goodbye"]]]

	assert_equal expected, XParse.new(schema).parse(data)
end

def test_symbols
	data = [:top, :x, :y, [:special, "hello"] , 
		[:normal, :x, :y, [:special, "goodbye"]], :x, :y]
	schema = [[:top, :x, :y]]
	expected = [[:top, :x, :y, :x, :y, :x, :y]]

	assert_equal expected, XParse.new(schema).parse(data)
end

def test_symbols_recursize_problem
	data = [:top, [:top, [:special, "goodbye"], :x], :y]

	schema = [:top, :x, :y]
	schema = [schema << schema]
	puts "SCHEMA:" + schema.inspect
	expected = [[:top, [:top, :x], :y]]
	
	assert_equal expected, XParse.new(schema).parse(data)
end

def test_symbols_recursion
	data = [:top, [:top, [:top, :x], [:top], :y] ,[:top, :x, :y]]

	schema = [:top, :x, :y]
	schema = [schema << schema]
	puts "SCHEMA:" + schema.inspect
	expected = [[:top, [:top, [:top, :x], [:top], :y], [:top,:x,:y]]]
	
	assert_equal expected, XParse.new(schema).parse(data)
end

def test_symbols_recursize
	data = [:top, :x, :y, [:special, "hello"] , 
			[:normal, :x, :y, [:special, "goodbye"]], :x, :y,
			[:top, :y, :x, [:top, [:special, "goodbye"], :x]]]
	schema = [:top, :x, :y]
	schema = [schema << schema]
	
	puts "SCHEMA:" + schema.inspect
	expected = [[:top, :x, :y, :x, :y, :x, :y, [:top, :y, :x, [:top, :x]]]]

	assert_equal expected, XParse.new(schema).parse(data)
end

end;end