require 'test/unit'
require 'ruby_parser'
require 'parse_tree'
require 'unified_ruby'
require 'symbol_parser'
require 'class_herd/parser'
module ClassHerd

class ClassHerd::TestSymbolParser < Test::Unit::TestCase #parses symbols structure from a .rb file.
include Test::Unit

def parse(file)
	 file = "examples/" + file + ".rb"
	 sexp = RubyParser.new.parse(File.open(file).read)
	 @sym_parse.parse(sexp)
end

def assert_parse(expect,name)
	file = "examples/" + name + ".rb"
	require "examples/" + name 
	klass = eval(name.split("_").collect{|it| it.capitalize}.join)
	assert Class === klass
	code = File.open(file).read

	sexp = Parser.parse_code(code)
	sexp2 = Parser.parse_code_pt(code)
	sexp3 = Parser.parse_class(klass)
	
	assert_equal sexp,sexp2

	assert_equal sexp2,sexp3

	assert_equal expect,SymbolParser.new.parse(sexp)
	assert_equal expect,SymbolParser.new.parse(sexp2)
	assert_equal expect,SymbolParser.new.parse(sexp3)
end

def setup
	@sym_parse = SymbolParser.new
end

def test_empty_class
	assert_parse [:class, [:const, :EmptyClass] , nil], "empty_class"
end
def test_simple_class
	assert_parse [:class, [:const, :SimpleClass], nil , [:const, :String]], "simple_class"
end

def test_array_tree
	a = [:a,:b]
	a  << :c
	assert_equal [:a,:b,:c], a

	b = [:d,:e]
	c = [:h,:j]
	b  <<  c
	
	assert_equal [:d,:e,[:h,:j]], b
	d = [:m,:n]
	c = b  << d
	assert_equal(c,b)
	assert_equal [:d,:e,[:h,:j], [:m,:n]], b
end
def test_array_weird
	b1 = [:d,:e]
	b2 = [:d,:e]
	c = [:h,:j]
	b1 <<  c
	b2 <<  c
	assert_equal [:d,:e,[:h,:j]], b1
	assert_equal [:d,:e,[:h,:j]], b2
	d = [:m,:n]
	b1 << d
	assert_equal [:d,:e,[:h,:j], [:m,:n]], b1
	b2 = b2 << d
	assert_equal [:d,:e,[:h,:j], [:m,:n]], b2
end

def test_inner_class
	#puts "TEST INNER CLASS"
	
	#fixing this was a surpise. it just happened... that probably means i'm in for trouble later...
	
	assert_parse([:class, [:const, :OuterClass] , nil, [:const, :String],
			[:class, [:const, :InnerClass], nil, 
			[:const, :Integer]]],"outer_class")

	puts "END TEST INNER CLASS"
end

def test_colon2_class
	#this part was actually easy. got it first time...
	assert_parse([:class, [:const, :Colon2Class] , nil,
		[:const, :Test, :Unit]],"colon2_class")
end

def test_test_primes
	assert_parse([:class,
 [:const, :TestPrimes],
 [:const, :Test, :Unit, :TestCase],
 [:const, :Primes]],"test_primes")
end

end;end