
require 'class_conductor2'
require 'test/unit'


module ClassHerd
class ClassHerd::TestClassConductor2 < Test::Unit::TestCase 
	
	include Test::Unit

	class Lom; end
	class Ras; end
	class Zax; end
	class Gav; end
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

	def test_replace_1level
		rcc = ClassConductor2.for(Rak)#might want to nice up the interface here...
		rcc.replace(:Lom,Zax)
		r2 = rcc.create
		
		assert r2.fump.is_a? Zax
		assert r2.goo.is_a? Ras

		rcc.replace(:Lom,Zax).replace(:Ras,Zhaf)
		r2 = rcc.create
		
		assert r2.fump.is_a? Zax
		assert r2.goo.is_a? Zhaf
		assert r2.goo.hu.is_a? Gav
		assert r2.goo.wim.is_a? Kiki

		r = Rak.new
		
		assert r.fump.is_a? Lom
		assert r.goo.is_a? Ras
	end
	
	def test_replace_2level
		rcc = ClassConductor2.for(Rak)#might want to nice up the interface here...
		
		rcc.replace(:Lom,Zax).replace(:Ras,	
			 ClassConductor2.for(Zhaf).replace(:Gav,Zax).klass		 
			 )
		r2 = rcc.create

		assert r2.fump.is_a? Zax
		assert_equal "Zhaf", r2.goo.what

		#here is a little problem:
		#when zhaf is duplicated it forgets what it is...
		#extend would avoid this, but wouldn't let you shadow things...
		#maybe the solution is to replace is_a? and so on...

		#maybe replace the class comparison methods
		#so that they behave as if a reconfigured class is actually a subclass.
		#or even ==?

		#assert r2.goo.is_a? Zhaf
		assert r2.goo.hu.is_a? Zax
		assert r2.goo.wim.is_a? Kiki
	end


end
end