
require 'class_herd/class_conductor3'
require 'class_herd/class_references4'
require 'test/unit'


module ClassHerd
class ClassHerd::TestClassConductor3 < Test::Unit::TestCase 
	
	include Test::Unit
	#extend ClassHerd::ClassConductor3
	include ClassHerd::ClassConductor3
	class Lom; end
	class Ras; end
	class Zax; end
	class Gav < Lom; end
	class Kiki; end
	class Zhaf
		attr_accessor :hu, :wim
		def initialize
			@hu = Gav.new
			@wim = Kiki.new
		end
		def what; "Zhaf"; end
	end

	class Rak 
		attr_accessor :fump, :goo
		def initialize
			@fump = Lom.new
			@goo = Ras.new
		end
	end

	def test__replace_1level
		rcc = _on(Rak)#might want to nice up the interface here...
		rcc._replace(:Lom,Zax)
		r2 = rcc.new

		assert r2.fump.is_a? Zax
		assert r2.goo.is_a? Ras

		rcc._replace(:Lom,Zax)._replace(:Ras,Zhaf)
		r2 = rcc.new
		
		assert r2.fump.is_a? Zax
		assert r2.goo.is_a? Zhaf
		assert r2.goo.hu.is_a? Gav
		assert r2.goo.wim.is_a? Kiki

		r = Rak.new
		
		assert r.fump.is_a? Lom
		assert r.goo.is_a? Ras
		
		assert_equal ({:Lom => Zax, :Ras => Zhaf}, rcc._rewires)
		assert_equal ({:Lom => Zax, :Ras => Zhaf}, rcc._wiring)
		assert_equal ({:Lom => Lom, :Ras => Ras}, Rak._wiring)
	end
	def test_self_reference
		rcc = _on(Rak)#might want to nice up the interface here...
		rcc._replace(:Lom,rcc)
		##rcc.new #->stack overflow
	end
	def test__replace_2level
		rcc = _on(Rak)#might want to nice up the interface here...
		
		rcc._replace(:Lom,Zax)._replace(:Ras,	
			 _on(Zhaf)._replace(:Gav,Zax)
			 )
		r2 = rcc.new

		assert r2.fump.is_a? Zax
		assert_equal "Zhaf", r2.goo.what

		#here is a little problem:
		#when zhaf is duplicated it forgets what it is...
		#extend would avoid this, but wouldn't let you shadow things...
		#maybe the solution is to _replace is_a? and so on...

		#maybe _replace the class comparison methods
		#so that they behave as if a reconfigured class is actually a subclass.
		#or even ==?
		puts "Zhaf: #{r2.goo.class} #{r2.goo.class.duped}"
		assert r2.goo.class == Zhaf
		#assert r2.goo.is_a? Zhaf
		assert r2.goo.hu.is_a? Zax
		assert r2.goo.wim.is_a? Kiki
		assert_equal ({:Lom => Zax, :Ras => Zhaf}, rcc._rewires)
		assert_equal ({:Lom => Zax, :Ras => Zhaf}, rcc._wiring)

	end
	
	#this defines how dups should appear the same.
	#might need to further this. but lots of decisions to make, and not sure what the effects will be yet.
	def test_class_relations
	l = _on(Lom)
	assert_equal l,Lom

	g = _on(Gav)

	assert_equal Lom,g.superclass
	assert  Lom > Gav 
	assert  Gav < Lom
	assert  Lom > g
	assert  g < Lom
	
	g1 = g.new
	l1 = l.new

	assert g1.is_a? Gav
	assert g1.is_a? Lom
	assert l1.is_a? Lom

	assert_equal ({}, g._rewires)
	assert_equal ({}, l._rewires)
	assert_equal ({}, g._wiring)
	assert_equal ({}, l._wiring)
	end
	#what about if there are several layers, with different configurations.
end
end