require 'yaml'
require 'monkeypatch/array'

module Test
module Unit
class TestCase

	def assert_same_set (s1,s2)
		assert s1.same_set?(s2), "expected #{s1.inspect}.same_set? #{s2.inspect}"
	end
        def assert_sub_set (s1,s2)
                assert s1.sub_set?(s2), "expected #{s1.inspect}.sub_set? #{s2.inspect}"
        end

        def assert_equal_yaml (s1,s2, m ="")
		assert_equal s1.to_yaml, s2.to_yaml, m
        end


end;end;end
