require "test/unit"
require "class_conductor"
require "v_c_r"


module ClassHerd

	class ClassHerd::TestClassConductor < Test::Unit::TestCase

		class StackTracer
			attr_accessor :stacktrace
			def initialize 
				@stacktrace = caller
			end
		end

		class String2 < String
		end
		class String3 < String
		end

	# what about using this class to test other candidate ClassConductors? 
	#maybe we need a way to run tests in a different process or VM so that 
	# they can crash without bringing down this thread... especially for problems like this one.

		REGEX_ClassConductor  = /(.*\/|^)class_conductor\.rb.*/

		def test_intercept
			cc = ClassConductor.new
			cc. activate
			
			st = StackTracer.new
			assert st.stacktrace.find {|it| it =~ REGEX_ClassConductor  }
			
			cc.deactivate
			st2 = StackTracer.new
			assert_nil st2.stacktrace.find {|it| it =~ REGEX_ClassConductor  }
		end

#question: what sort of behaviour should be expected in these cases:
# 1.A->B: 
#ask for A get B.
# 2. A->B, B->C
# 3. A->B, B->A
# if 2 means ask for A, get C, what does 3 mean? it means crash.
# else 3 means ask for A get B, but ask for B, get A.
# and 2 means ask for A get B, ask for B get C
#this second interperation has less failor modes.
#also, this turned out very simple to implement!

		def test_subsitute
			cc = ClassConductor.new
			cc. activate

			cc.newrule("test_subsitute").replace(String,String2)
			
			s = String.new
			s2 = String2.new
			
			assert s.is_a? String2
			assert s2.is_a? String2
			
			cc.newrule("test_subsitute-2").replace(String3,String)

			s3 = String3.new
			
			assert s3.is_a? String

			cc.newrule("test_subsitute-3").replace(String2,String3)
			s2 = String2.new
			s = String.new
			assert s.is_a? String2
			assert s2.is_a? String3

			cc.deactivate
		end
		
		def test_wrap_every
			cc = ClassConductor.new
			cc. activate
	
			cc.newrule("wrapeverything").wrap {|obj| VCR.class_conductor_aliased_new(obj)}
			x = String.new("hello")

			assert x.is_a?(VCR)
			assert x.wrapped.is_a?(String)

			assert_equal "hello", x.to_s

			cc.deactivate
		end
		class Array2 < Array
		end
		
		def test_selected
			#if it's an number call a wrap function to convert to string.
			cc = ClassConductor.new
			cc. activate
			r = cc.newrule("array to string")
#			r.test {|t| 
			#puts "TEST"
#			t.class == Array2
#			}
			r.wrap {|n| n.class == Array2 && n.to_s || n}#build test behaviour into wrap block...

			assert (Array2.new.is_a?(String))
			assert (Array.new.is_a?(Array))
			cc.deactivate
		end

		def test_replace_with_test

			#use a test method to control replace
			#use Array2 instead of array, but only for Arrays with length > 3
			cc = ClassConductor.new
			cc. activate
			r = cc.newrule("Array > 3 to Array2")
			r.replace(Array,Array2)
			r.test {|t,b| b.is_a?(Array) && b.length > 3}#the first 

			r = cc.newrule("Array2(>5) to Array")
			r.replace(Array2,Array)
			r.test {|t,b| b.is_a?(Numeric) && b > 5}#the first 

			#oh, woops, we don't know the length yet. all the test can know is the class.
			# we need to distinct between test for wrap and test for replace?
			#well, wrap already has a block, so why not give test to replace?
			
			a = Array.new
			a2 = Array.new([1,2,3,4])
			a3 = Array.new(10)
			a4 = Array2.new(4)
			a5 = Array2.new(10)

			assert_equal Array, a.class 
			assert_equal Array2, a2.class 
			assert_equal Array, a3.class 
			assert_equal Array2, a4.class 
			assert_equal Array, a5.class 

			assert_equal 0, a.length
			assert_equal 4, a2.length
			assert_equal 10, a3.length
			assert_equal 4, a4.length
			assert_equal 10, a5.length

			cc.deactivate
		end

			#and pass the args...
			#ClassConductor needs to be clever about what args it passes to the test.
			# wow, ruby figures it out it self! 
			#~ you can go 
			#~ kak = Proc.new{|ni| puts ni}
			#~ def mon(*args)
				#~ kak.call(*args)
			#~ end
			#~ mon(1,Bu,zuk)
			#~ >output will be "1"


		def trim_args(func,*args, &block)
				if func.arity >= 1  then arity = func.arity  - 1
				else arity = args.length  end
			func.call(*args[0..arity],&block)
		end

		def test_varargs 
			kak = lambda {|nin| "{#{nin}}"}
			assert_equal "{mug}", kak.call("mug")
			assert_equal "{mugmug}", kak.call("mug","mug")
			zum = lambda {|nin| "{#{nin}} #{nin.is_a? Array}"}
			assert_equal "{mugmug} true",zum.call("mug","mug")
			
			# cut extra args
			assert_equal 1,kak.arity
			assert_equal "{mug}", trim_args(kak,"mug","FID") {fail "shouldn't have called this block"}
			
			assert_equal "{zam}",kak.call("zam") {fail "shouldn't have called this block"}
			assert_equal "{zam}", trim_args(kak,"zam") {fail "shouldn't have called this block"}
			
			#what if you trim args when you want var args?
			
			far = lambda {|*args| args.length}
			assert_equal -1, far.arity
			assert_equal 5,trim_args(far, 1,2,3,4,5)
			
			none = lambda {36}
			assert_equal 36,trim_args(none, 1,2,3,4,5)
			
		end
	end
end
