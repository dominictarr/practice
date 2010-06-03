require 'test/unit'
require 'class_herd/file_explorer'
require 'monkeypatch/TestCase'

module ClassHerd 
class TestFileExplorer < Test::Unit::TestCase
	EXAMPLE_PATH = './class_herd/'
	def test_examples
		ex = FileExplorer.new(EXAMPLE_PATH + "examples")
		assert_equal [EXAMPLE_PATH + "examples/empty_class.rb"], 
					ex.rb_for_symb(:EmptyClass)
		assert_equal [EXAMPLE_PATH + "examples/example_modules.rb"], 
					ex.rb_for_symb(:"Module1::Class1")
		assert_equal [EXAMPLE_PATH + "examples/outer_class.rb"], 
					ex.rb_for_symb(:"OuterClass::InnerClass")
		assert_same_set [EXAMPLE_PATH + "examples/example_modules_2.rb",
				EXAMPLE_PATH + "examples/example_modules.rb"], 
					ex.rb_for_symb(:"Module1")
	end
	def test_recursive
		puts "TEST RECURSIVE"
		path = '.'
		ex = FileExplorer.new(path)
		assert_equal [EXAMPLE_PATH + "examples/empty_class.rb"], 
					ex.rb_for_symb(:EmptyClass)
		assert_equal [EXAMPLE_PATH + "test_file_explorer.rb"],
					ex.rb_for_symb(:"ClassHerd::TestFileExplorer")
		#ex.explore_path
end
end;end
	
