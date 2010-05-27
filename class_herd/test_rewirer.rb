
require 'class_herd/rewirer'
require 'class_herd/class_references4'
require 'test/unit'

module ClassHerd
class TestRewirer < Test::Unit::TestCase 
	
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
		rcc = Rewirer.new.for(Rak)#might want to nice up the interface here...
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
		rcc = Rewirer.new.for(Rak)#might want to nice up the interface here...
		
		rcc.replace(:Lom,Zax).replace(:Ras,	
			 Rewirer.new.for(Zhaf).replace(:Gav,Zax).klass		 
			 )
		r2 = rcc.create
		assert_equal ({:Lom => Zax, :Ras => Zhaf},rcc.klass._rewires)
		assert_equal ({:Gav => Zax},rcc.klass._rewires[:Ras]._rewires)

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
	
	def test_references
		cr = ClassReferences4.new
		cr.parse(Zhaf)
		
		rcc = Rewirer.new.for(Zhaf).replace(:Gav,Zax)
		cr2 = ClassReferences4.new
		cr2.parse(rcc.klass,true)
		assert_equal ({:Gav => Zax},rcc.klass._rewires)
		
		#~ puts cr.sexp.inspect
		#~ puts cr.reffs.inspect
		#~ puts cr2.sexp.inspect
		#~ puts cr2.reffs.inspect
		z1 = Zhaf.new
		z2 = rcc.klass.new
		
		assert Gav === z1.hu, "expected Gav === z1.hu"
		assert !(Zax === z1.hu), "expected Gav === z1.hu"
		assert Zax === z2.hu, "expected Zax === z2.hu"
		assert !(Gav === z2.hu), "expected Zax === z2.hu"

#		puts "%%REPLACEMENTS"
		assert rcc.klass.is_duplicated?, "expected z2.is_duplicated"

#	puts rcc.klass.replacements.inspect
#	puts Rewirer.new.for(rcc.klass).klass.replacements.inspect
#	puts rcc.reffs.inspect

	rcc2 = Rewirer.new.for(rcc.klass)
	assert_equal ({:Gav => Zax},rcc.klass._rewires)
#	puts rcc2.klass.replacements.inspect
#	puts rcc2.reffs.inspect

	z3 = rcc2.create
		assert Zax === z3.hu, "expected Ras === z2.hu"
	rcc2.replace(:Gav, Ras)
	assert_equal ({:Gav => Ras},rcc2.klass._rewires)
#	puts rcc2.reffs.inspect
#	puts rcc2.klass.replacements.inspect
	z3 = rcc2.create
		assert Ras === z3.hu, "expected Ras === z2.hu"

	end
end;end