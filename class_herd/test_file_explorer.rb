require 'test/unit'
require 'class_herd/file_explorer'

module ClassHerd 
class TestFileExplorer < Test::Unit::TestCase
	def test_examples
		ex = FileExplorer.new("examples")
		assert_equal ["examples/empty_class.rb"], 
					ex.rb_for_symb(:EmptyClass)
		assert_equal ["examples/example_modules.rb"], 
					ex.rb_for_symb(:"Module1::Class1")
		assert_equal ["examples/outer_class.rb"], 
					ex.rb_for_symb(:"OuterClass::InnerClass")
		assert_equal ["examples/example_modules_2.rb","examples/example_modules.rb"], 
					ex.rb_for_symb(:"Module1")
	end
	def test_recursive
		ex = FileExplorer.new(".")
		assert_equal ["./examples/empty_class.rb"], 
					ex.rb_for_symb(:EmptyClass)
		assert_equal ["./test_file_explorer.rb"],
					ex.rb_for_symb(:"ClassHerd::TestFileExplorer")
		ex.explore_path
end
end;end
	