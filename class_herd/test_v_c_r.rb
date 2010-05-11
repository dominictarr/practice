require 'test/unit'
require 'class_herd/v_c_r'

module ClassHerd 
# class to infer the interface a test tests.

# extend Kernel.new and wrap each class in a VCR
# VCR passes each call to the inner class and returns the result, but also logs the call.
# afterwards, list all the classes, and all the calls.

#afterwards, look into being aware of the tree of classes creating classes.

#plan:
#test VCR class.
#~ VCR.new (klass, *args)
#~ wrap a new klass.new(args) in a VCR

# why not just have VCR.new(object)?
# it's just VCR.new(klass.new(args))... much simpler.


#~ make calls to VCR, get results returned from klass.
#~ query VCR for the calls made: VCR.interface
#~ ask VCR if another class has the same interface VCR.hasInterface?
# ~ get wrapped object VCR.wrapped

#remember testing has_interface? when there is a method which takes a block.

class TestVCR < Test::Unit::TestCase 
	
	def setup 
			
		end
		
	def test_new
		
		vcr = VCR.new("hello")
		assert_equal("hello",vcr.wrapped)
	end

	def test_return
		vcr = VCR.new("hello")
		assert_equal(5,vcr.length)
		assert_equal("HELLO",vcr.upcase())
		assert_equal("hell",vcr[0..3])
	end
	
	def test_interface
		vcr = VCR.new("hello")
		vcr.length
		vcr.capitalize()
		vcr[0..3]
		
		#assert_equal(['length',vcr.interface
	#	puts "INTERFACE:"
	#	puts vcr.interface
		#fail "test not yet written"
		assert_equal [:length,:capitalize,:[]], vcr.interface
		#so far, so good.
		
		assert vcr.has_interface?(String)
		assert_equal false ,vcr.has_interface?(Array)
	end
	
	def test_is_a?
		vcr = VCR.new("hello")
		#assert_equal String, vcr.class
		assert vcr.is_a? String
		
	end

	def test_equal_subclass?
		s = String.new("hello")
		s2 = Class.new(String).new("hello")
		s3 = String.dup.new("hello")
		assert_equal (s,s2)
		assert_equal (s,s3)
		assert_equal (s2,s3)
		end

#	def test_equal?
#		vcr = VCR.new("hello")
		#assert_equal vcr, "hello"
#		vcr2 = VCR.new("goodbye")
#		assert vcr != vcr2
#		assert_equal "hello", vcr
#		assert vcr == "hello"
		#assert_equal String, vcr.class
#	end

	
end
end