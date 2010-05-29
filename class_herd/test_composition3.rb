require 'test/unit'
require 'yaml'
require 'class_herd/composition3'
require 'class_herd/test_rewirer'

module ClassHerd
class TestComposition3 < Test::Unit::TestCase
include Test::Unit

def test_single
	#single inital class.
	c = Composition3.new
	c.use(TestRewirer::Ras)
	assert_equal [TestRewirer::Ras.name], c.composition
	c2 = Composition3.new(TestRewirer::Ras)
	assert_equal [TestRewirer::Ras.name], c2.composition
	end

def test_multiple

	c = Composition3.new

	c.use(TestRewirer::Zhaf).
		replace(:Kiki,TestRewirer::Ras)
	assert_equal [TestRewirer::Zhaf.name, 
				{:Kiki => [TestRewirer::Ras.name]}], c.composition

	c2 = Composition3.new
	c2.use(TestRewirer::Zhaf).#default wiring for Zhaf
		replace(:Kiki,TestRewirer::Kiki).
		replace(:Gav,TestRewirer::Gav)
	
	c3 = Composition3.new(TestRewirer::Zhaf)
	assert_equal c2.composition,c3.composition
	assert_equal c2,c3

end
def test_two_level
	c = Composition3.new

	c.use(TestRewirer::Zhaf).
		replace(:Kiki,TestRewirer::Ras).
		replace(:Gav,c.use(TestRewirer::Rak).
			replace(:Lom, TestRewirer::Ras))

	assert_equal [TestRewirer::Zhaf.name, 
				{:Kiki => ras = [TestRewirer::Ras.name],
				:Gav => [TestRewirer::Rak.name, {:Lom => ras}]
				}], c.composition
	arry = [TestRewirer::Zhaf.name, 
				{:Kiki => ras = [TestRewirer::Ras.name],
				:Gav => [TestRewirer::Rak.name, 
					{:Lom => [TestRewirer::Ras.name]}]
				}]
	assert_equal arry, c.composition
	assert arry.to_yaml != c.composition.to_yaml
		#puts arry.to_yaml 
		#puts c.composition.to_yaml
end
#~ def test_with_named
	#~ c = Composition2.new

	#~ c.use(TestRewirer::Zhaf).
		#~ replace(:Kiki,c2 = c.use(TestRewirer::Rak).
			#~ replace(:Lom,TestRewirer::Gav).
			#~ replace(:Ras,TestRewirer::Zax)).
		#~ replace(:Gav,c2)
	#~ ##~ d.use(TestRewirer::Zhaf).
		#~ ##~ replace(:Kiki,c.use(TestRewirer::Rak).
			#~ ##~ replace(:Lom,TestRewirer::Gav).
			#~ ##~ replace(:Ras,TestRewirer::Zax)).
		#~ ##~ replace(:Gav,c.use(TestRewirer::Rak).
			#~ ##~ replace(:Lom,TestRewirer::Gav).
			#~ ##~ replace(:Ras,TestRewirer::Zax))

	#~ assert_equal c.map[:Kiki],c.map[:Gav]
	#~ assert_equal c.map[:Kiki].object_id,c.map[:Gav].object_id
	#~ kmap = c.classes._wiring
	#~ assert_equal kmap[:Kiki].object_id,kmap[:Gav].object_id, "classes created by same Composition2 should be same object"
	#~ assert_equal c, d = Composition2.new(c.classes)
	#~ assert_equal d.map[:Kiki].object_id,d.map[:Gav].object_id
#~ end

def test_self_reference
	c = Composition3.new
	c.use(TestRewirer::Zhaf).
		replace(:Kiki,c).
		replace(:Gav,TestRewirer::Zax)
	
	map = {:Gav => [TestRewirer::Zax.name]}
	z = [TestRewirer::Zhaf.name, map]
	map[:Kiki] = z 
	assert_equal  z.to_yaml, c.composition.to_yaml
	assert_equal(z, c.composition)	
end
end;end
