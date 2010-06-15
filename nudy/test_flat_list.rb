require 'test/unit'
require 'nudy/flat_list'

class TestFlatList  < Test::Unit::TestCase 
include Test::Unit

	def assert_flat_list (f1,is_flat,is_same_type,what_type = Object)

		assert_equal is_flat, f1.is_flat?, "#{f1.inspect}.is_flat?"
		assert_equal is_same_type,f1.is_same_type?, "#{f1.inspect}.is_same_type?"
		assert_equal what_type, f1.what_type?, "#{f1.inspect}.what_type?"
	end

def test_is_flat?

	assert_flat_list(f1 = FlatList.new([:a,:b,:c]),true,true,Symbol)
	
	assert_flat_list(n1 = FlatList.new([:a,:b,:c,[123,456]]),false,false)

	assert_flat_list(f1 = FlatList.new([:a,"String",:c]),true,false,Object)
end

def test_common_superclass
	
end

end
