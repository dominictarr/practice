require 'test/unit'
require 'psychic/psychic'
require 'ap'
class TestPsychic < Test::Unit::TestCase
include Test::Unit
	#Psychic can make observe any object. 
	#it's powers from from metaprogramming the subject, 
	#aliasing mutable methods with methods which call's a closure
	#and then calling the old method.

	def test_simple
		called = false
		Psychic.connect(h = "Hello", :length) {|obj,method,value,*args|
			assert_equal h,obj
			assert_equal :length,method
			assert_equal 5,value
			assert_equal [],args #also test on something wit args
			called = true
		}
		assert_equal 5,h.length
		assert called, "expected psychic connection on \"#{h}\".length"
	end

	def test_with_args
		called = 0
		deleted = []
		Psychic.connect(h = [:a,:b,:c], :delete) {|obj,method,value,*args,&block|
			assert_equal h,obj
			assert_equal :delete,method
			assert  Symbol === value
			assert_equal [value] ,args
			deleted << value
			called = called + 1
		}
		h.delete :a
		h.delete :b
		h.delete :c

		assert_equal 3,called
		assert_equal deleted,[:a,:b,:c]
	end 

	def test_multiple_connections

		b_delete = b_called = called = 0
		deleted = []
		
		Psychic.connect(h = [:a,:b,:c], :delete) {|obj,method,value,*args|
			assert_equal h,obj
			assert_equal :delete,method
			assert  Symbol === value
			assert_equal [value] ,args
			deleted << value
			called = called + 1
		}
		Psychic.connect(h,:"<<", :delete) {|obj,method,value,*args|
			assert_equal h,obj
			b_called = b_called + 1
			if method == :delete then
				b_delete = b_delete + 1
			end
		}
		h.delete :a
		h.delete :b
		h.delete :c
		h << :d
		h << :e
		h << :f

		assert_equal 3,called
		assert_equal 6,b_called
		assert_equal 3,called
		assert_equal deleted,[:a,:b,:c]
	end

	def test_disconnect
		h = "Hello"
		called = false
		p = proc {|obj,method,value,*args,&block|
			assert_equal h,obj
			assert_equal :length,method
			assert_equal 5,value
			assert_equal [],args #also test on something wit args
			called = true
		}
		Psychic.connect(h, :length,&p)

		assert_equal 5,h.length
		assert called, "expected psychic connection on \"#{h}\".length"
		Psychic.disconnect(h,:length,&p)
		called = false
		assert_equal 5,h.length
		assert !called, "expected psychic connection disconnected on \"#{h}\".length"
		
	end


	def expect (state,code)
		assert state, "closure was not called for opperation: \"#{code}\""
		false
	end	
	def test_array
		before = nil		
		a = []
		c = false
		Psychic.connect_mutable(a) {|object,method,value,*args,&block|
			ap "#{before.inspect}.#{method}(#{args.join(',')}) => #{object.inspect}"
			c = true
		}
		code = "a << :a
		a.delete :a
		a << :a
		a << :b
		a << :c
		a.reverse!
		a.reverse!"
		b = binding
		code.split("\n").each{|s| 
			before = a.dup
			eval(s,b); 
			c = expect(c,s)
			assert a != before, "expected opperation: #{s} to alter #{a.inspect} from #{before.inspect}"
		}


	end

	def test_hash
		
	end

end
