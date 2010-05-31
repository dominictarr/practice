require 'test/unit'
require 'yaml'
require 'class_herd/composition2'
require 'class_herd/test_rewirer'

module ClassHerd
class TestComposition2 < Test::Unit::TestCase
include Test::Unit

#~ def test_single
	#~ #single inital class.
	#~ c = Composition2.new
	#~ c.use(String)
	#~ asserts = proc { |c|
		#~ assert_equal(String,c.using)
		#~ assert_equal String, c.classes
		#~ assert c.classes.is_duplicated?, "expected #{c.classes.inspect} to be duplicated."
		#~ assert "hello", c.create("hello") 
		#~ assert Composition2.new(c.classes),c
	#~ }
	#~ asserts.call(c)
	#~ y = YAML::load(c.to_yaml)
	#~ puts c.to_yaml
	#~ asserts.call(y)
#~ end

def test_multiple
	c = Composition2.new
	c.use(TestRewirer::Zhaf).replace(:Kiki,TestRewirer::Ras).replace(:Gav,TestRewirer::Zax)
	
	asserts = proc {|c|
		assert_equal TestRewirer::Zhaf,c.using
		assert_equal(
			{:Kiki => TestRewirer::Ras.name,
				:Gav => TestRewirer::Zax.name},
			c.map)
		assert_equal TestRewirer::Zhaf, c.classes
		assert c.classes.is_duplicated?, "expected #{c.classes.inspect} to be duplicated."
		assert !(c.classes.constants.empty?)

		assert_equal ({:Kiki => TestRewirer::Ras,
				:Gav => TestRewirer::Zax}, c.classes._rewires)
		assert_equal ({:Kiki => TestRewirer::Ras,
				:Gav => TestRewirer::Zax}, c.classes._wiring)
	}

	asserts.call(c)
	y = YAML::load(c.to_yaml)
	asserts.call(y)
	assert_equal(c,Composition2.new(c.classes))
#	assert_equal(Composition2.new.of(y.classes),c)
end
def test_two_level
	c = Composition2.new

	c.use(TestRewirer::Zhaf).
		replace(:Kiki,TestRewirer::Ras).
		replace(:Gav,c2 = c.use(TestRewirer::Rak).
			replace(:Lom,TestRewirer::Gav).
			replace(:Ras,TestRewirer::Zax))
	assert_equal (c.map,{:Kiki => TestRewirer::Ras.name,:Gav => c2})
		
	#now, tests that it actually has changed.
	#i've got more than three tests for this 
	#functionality for classes with different interfaces.
	#maybe there is a way to use just one test?

	assert c.classes
	assert_equal ({:Kiki => TestRewirer::Ras,
			:Gav => TestRewirer::Rak}, c.classes._rewires)
	assert_equal ({:Lom => TestRewirer::Gav,
			:Ras => TestRewirer::Zax}, c.classes._rewires[:Gav]._rewires)

	assert_equal c, Composition2.new(c.classes)
end
def test_with_named
	c = Composition2.new

	c.use(TestRewirer::Zhaf).
		replace(:Kiki,c2 = c.use(TestRewirer::Rak).
			replace(:Lom,TestRewirer::Gav).
			replace(:Ras,TestRewirer::Zax)).
		replace(:Gav,c2)
	#~ d.use(TestRewirer::Zhaf).
		#~ replace(:Kiki,c.use(TestRewirer::Rak).
			#~ replace(:Lom,TestRewirer::Gav).
			#~ replace(:Ras,TestRewirer::Zax)).
		#~ replace(:Gav,c.use(TestRewirer::Rak).
			#~ replace(:Lom,TestRewirer::Gav).
			#~ replace(:Ras,TestRewirer::Zax))

	assert_equal c.map[:Kiki],c.map[:Gav]
	assert_equal c.map[:Kiki].object_id,c.map[:Gav].object_id
	kmap = c.classes._wiring
	assert_equal kmap[:Kiki].object_id,kmap[:Gav].object_id, "classes created by same Composition2 should be same object"
	assert_equal c, d = Composition2.new(c.classes)
	assert_equal d.map[:Kiki].object_id,d.map[:Gav].object_id
end

def test_self_reference
	c = Composition2.new
	c.use(TestRewirer::Zhaf).
		replace(:Kiki,c).
		replace(:Gav,TestRewirer::Zax)
	c.classes
#	assert_equal c, d = Composition2.new(c.classes)

	h = Hash.new
	h2 = Hash.new
	h[:hash] = h2
	h[:a] = "AAA"
	h[:one] = "one"
	h2[:hash] = h
	h2[:hash2] = h2
	puts h.to_yaml

end
end;end