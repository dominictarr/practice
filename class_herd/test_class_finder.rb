

require 'test/unit'
require 'class_herd/class_finder'
require 'class_herd/examples/outer_class'
require 'class_herd/examples/outer_class2'

module ClassHerd
class TestClassFinder < Test::Unit::TestCase
	include Test::Unit

class ExampleSubclass
	class ExampleSubclass2; end
end
def assert_find (looker,klass,symb)
	f = ClassFinder.new
	c = f.from_symbol(looker,symb)
	puts f.ref
	assert_equal klass,c
end
def test_this_module
	assert_find(self.class,ClassFinder,:ClassFinder)
	assert_find(self.class,ExampleSubclass,:ExampleSubclass)
	assert_find(self.class,ExampleSubclass::ExampleSubclass2,:"ExampleSubclass::ExampleSubclass2")
	assert_find(ExampleSubclass, ExampleSubclass::ExampleSubclass2,:ExampleSubclass2)
	#assert_find (self.class, ExampleSubclass::ExampleSubclass2,:ExampleSubclass2)
end
def test_no_module
	assert_find(self.class,OuterClass,:OuterClass)
	assert_find(OuterClass,OuterClass::InnerClass,:"OuterClass::InnerClass")
end
def test_different_module
	assert_find(self.class,Examples::OuterClass2,
			:"Examples::OuterClass2")
	assert_find(Examples::OuterClass2,
			Examples::OuterClass2::InnerClass2,
			:"InnerClass2")
	assert_find(self.class,Examples::OuterClass2::InnerClass2,
			:"Examples::OuterClass2::InnerClass2")
end
end;end
