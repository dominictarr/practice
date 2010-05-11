require "test/unit"
require "classherd/class_rule"

module ClassHerd

	class TestClassRule < Test::Unit::TestCase
	
	
		def test_replace?
		
			r = ClassRule.new "test_replace?"
			r.replace(Integer, String)
			
			assert_equal(String, r.replace?( Integer))
			puts "REPLACE? >#{ r.replace?(String)}<"
			assert_equal(nil, r.replace?(String))

		end
	

		def test_wrap_anything
			r = ClassRule.new "test_wrap?"
			r.wrap {|obj| obj.to_s}
			
		assert r.dowrap(10).is_a?(String)
		assert_equal "10", r.dowrap(10)
		assert_not_equal "10", 10
		
			r.wrap {|obj| String.new(obj.to_s)}

		assert r.dowrap(10).is_a?(String)
		assert_equal "10", r.dowrap(10)
		end
	
		def test_test
			r = ClassRule.new "test_String"
			r.test {|t| t.is_a? String}#first arg will be a class
			r2 = ClassRule.new "test_Array_with_size"
			r2.test {|t,b| t == Array && b.is_a?(Numeric)}
			



assert r.test?("hello")
			assert r2.test?(Array, 10)			
		end


	end
end
