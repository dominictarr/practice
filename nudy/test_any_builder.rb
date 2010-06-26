require 'test/unit'
require 'nudy/any_builder'
require 'nudy/test_view_builder'

class TestAnyBuilder < Test::Unit::TestCase
include Test::Unit
#builder which syntax, to easy creation of many similar objects.

SomeFields = TestViewBuilder::SomeFields

def test_simple
b = AnyBuilder.new 

sf = b.klass(SomeFields).defaults({'string=' => "hello", 'int=' => 1200}).build
assert_equal "hello",sf.string
assert_equal 1200,sf.int
end
def test_set_each
b = AnyBuilder.new 

sf_s = b.klass(SomeFields).defaults({'string=' => "hello", 'int=' => 1200}).attrs({'int=' => 1},{'int=' => 2},{'int=' => 3}).build
sf_s.each_index{|i|
	sf = sf_s[i]
	assert_equal "hello",sf.string
	assert_equal i + 1,sf.int
}
end

def test_set_table
b = AnyBuilder.new 

sf_s = b.klass(SomeFields).defaults({'string=' => "hello", 'int=' => 1200}).
table(['int=','string='],
		[[1,"1"],
		 [2,"2"],
		 [3,"3"],
		 [4,"4"],
		 [5,"5"]]).build

sf_s.each_index{|i|
	sf = sf_s[i]
	assert_equal i + 1,sf.int
	assert_equal (i + 1).to_s,sf.string
}
end
def test_set_table_onefield
b = AnyBuilder.new 

sf_s = b.klass(SomeFields).defaults({'string=' => "hello", 'int=' => 1200}).
table('int=',[1,2,3,4,5,6]).build

sf_s.each_index{|i|
	sf = sf_s[i]
	assert_equal i + 1,sf.int
	assert_equal "hello",sf.string
}
end


end
