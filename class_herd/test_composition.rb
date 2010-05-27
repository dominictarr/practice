require 'test/unit'
require 'class_herd/composition'
require 'yaml'
require 'class_herd/test_rewirer'

module ClassHerd
class TestComposition < Test::Unit::TestCase
include Test::Unit

def test_single
	#single inital class.
	c = Composition.new
	c.use(String)
	asserts = proc { |c|
		assert_equal ({:use => String.name},c.map)
		assert_equal String, c.classes
		assert c.classes.is_duplicated?, "expected #{c.classes.inspect} to be duplicated."
		assert "hello", c.create("hello") 
	}
	asserts.call(c)
	y = YAML::load(c.to_yaml)
	puts c.to_yaml
	asserts.call(y)
end

def test_multiple
	c = Composition.new
	c.use(TestRewirer::Zhaf).replace(:Kiki,TestRewirer::Ras).replace(:Gav,TestRewirer::Zax)
	
	asserts = proc {|c| 
		assert_equal (
			{:use => TestRewirer::Zhaf.name,
				:Kiki => TestRewirer::Ras.name,
				:Gav => TestRewirer::Zax.name},
			c.map)
		assert_equal TestRewirer::Zhaf, c.classes
		assert c.classes.is_duplicated?, "expected #{c.classes.inspect} to be duplicated."
		assert !(c.classes.constants.empty?)
		puts c.classes.constants.inspect
	}
	
	asserts.call(c)
	y = YAML::load(c.to_yaml)
	asserts.call(y)
end
def test_two_level
	c = Composition.new
	c.use(TestRewirer::Zhaf).
			replace(:Kiki,TestRewirer::Ras).
			replace(:Gav,c.use(TestRewirer::Rak).
					replace(:Lom,TestRewirer::Gav).
					replace(:Ras,TestRewirer::Zax))
	assert_equal ({:use => TestRewirer::Zhaf.name,
			:Kiki => TestRewirer::Ras.name,
			:Gav => {:use => TestRewirer::Rak.name,
				:Lom => TestRewirer::Gav.name,
				:Ras => TestRewirer::Zax.name}
			},c.map)
	
	#now, tests that it actually has changed.
	#i've got more than three tests for this 
	#functionality for classes with different interfaces.
	#maybe there is a way to use just one test?
end

end;end
