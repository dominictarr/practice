require 'test/unit'
require 'yaml'
require 'class_herd/composition3'
require 'class_herd/composer2'
require 'class_herd/test_rewirer'
require 'class_herd/interface_tester'
require 'class_herd/rewiring_tester'
require 'monkeypatch/class2'
require 'class_herd/file_explorer'
#require 'class_herd/test_interface_discovery'

module ClassHerd
class TestComposition3 < Test::Unit::TestCase
include Test::Unit

def test_single
	#single inital class.
	c = Composition3.new
	c.use(TestRewirer::Ras)
	assert_equal [TestRewirer::Ras.name], c.composition
	c2 = Composition3.new.read(TestRewirer::Ras)
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
	
	c3 = Composition3.new.read(TestRewirer::Zhaf)
	assert_equal c2.composition,c3.composition
	assert_equal c2.composition,c3.composition
	assert_equal c2,c3
end
#~ def test_map_equal
	#~ a = {:a => "AAA"}
	#~ a2 = {:a => "AAA"}
	#~ assert_equal a,a2
	
	#~ a[:a_ref] = a
	#~ a2[:a_ref] = a2
	#~ assert_equal a.to_yaml,a2.to_yaml
	#~ assert_equal a,a2
#~ end

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

def test_self_reference
	c = Composition3.new
	c.use(TestRewirer::Zhaf).
		replace(:Kiki,c).
		replace(:Gav,TestRewirer::Zax)
	
	map = {:Gav => [TestRewirer::Zax.name]}
	z = [TestRewirer::Zhaf.name, map]
	map[:Kiki] = z 
	assert_equal  z.to_yaml, c.composition.to_yaml
	#assert_equal(z, c.composition)	
end
def yaml_composition_defaults (klass,*defs)
	y = Composition3.new.
		defaults(*defs).
		read(klass).composition.to_yaml
	puts y
	y
end
def yaml_composition(klass)
	yaml_composition_defaults(klass,Object,Hash,Array,String,Class,Module,Exception)
end

def  test_composer
	yaml_composition(Composer2)
	yaml_composition(InterfaceDiscoveryWrapper)
	yaml_composition(YAML)
	yaml_composition(Rewirer)
	yaml_composition(FileExplorer)
	yaml_composition(Composition3)
	yaml_composition(TestRewirer)
	yaml_composition (RewiringTester)

	yaml_composition_defaults(Array,Object)
	yaml_composition_defaults(Hash,Object)
	yaml_composition_defaults(Exception,Object)
	yaml_composition_defaults(Class,Object)

#	yaml_composition(TestInterfaceDiscovery)
#ProcWrapper.new
#
end

end;end
