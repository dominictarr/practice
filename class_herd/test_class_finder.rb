require 'test/unit'
require 'class_herd/class_finder'
require 'class_herd/class_finder2'
require 'class_herd/examples/outer_class'
require 'class_herd/examples/outer_class2'
require 'class_herd/examples/some_constants2'

module ClassHerd
class TestClassFinder < Test::Unit::TestCase
	include Test::Unit

class ExampleSubclass
	class ExampleSubclass2; end
end
def assert_find (looker,klass,symb)
	f = ClassFinder2.new
	c = f.from_symbol(looker,symb)
	puts f.ref
	assert_equal klass,c
end
def test_this_module
	assert_find(self.class,self.class,:TestClassFinder)
	assert_find(self.class,ClassFinder2,:ClassFinder2)
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
#find a class which is required for a module which a class includes.
require 'class_herd/examples/another_empty_class'
	
def test_class_include_module_require
	#assert_find(self.class,ClassFinder2,:ClassFinder2)
	puts "expect AnotherEmptyClass => #{SomeConstants2.new.dont_do_it}"
	puts "expect DifferentModule::ModuleWithConstants::DoNothing => #{SomeConstants2.new.from_include}"
	puts "expect DifferentModule::AnotherEmptyClass=> #{eval("DifferentModule::AnotherEmptyClass")}"
	puts SomeConstants2.new.from_include.class.ancestors.inspect
	assert_equal DifferentModule::AnotherEmptyClass,SomeConstants2.new.dont_do_it.class
	#okay, SomeConstants.new.from_include returns a new DifferentModule::ModuleWithConstants::DoNothing
	looker = SomeConstants2
	symb = :AnotherEmptyClass
	f = ClassFinder2.new
	c = f.from_symbol(looker,symb)
	assert c
	puts "test_class_include_module_require: #{c}"
end


end;end
