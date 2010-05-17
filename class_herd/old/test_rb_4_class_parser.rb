require 'test/unit'
require 'class_herd/file_explorer'

module ClassHerd 
class TestRb4ClassParser < Test::Unit::TestCase
	def test_examples
		p = Rb4ClassParser.new("examples/empty_class.rb")
		assert_equal [:EmptyClass], p.class_symbols_for_rb
		p = Rb4ClassParser.new("examples/outer_class.rb")
		assert_equal [:OuterClass,:"OuterClass::InnerClass"], p.class_symbols_for_rb
		
	end	
end;end
	