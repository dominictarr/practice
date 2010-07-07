require 'rubygems'
require 'test/unit'
require 'tools/table'

class TestTable < Test::Unit::TestCase 

class Greeting
	quick_attr :greeting,:number
	def initialize (h,i) greeting(h); number(i) end
end
def test_object_array
	table = Table.new.tabulate(Greeting.new("hello",1),Greeting.new( "bonjour",2),Greeting.new( "guten tag",3)).headers (:greeting)
	t = table.table
	assert_equal [["hello"],["bonjour"],["guten tag"]],t
	table = Table.new.tabulate(Greeting.new("hello",1),Greeting.new( "bonjour",2),Greeting.new( "guten tag",3)).headers (:number,:greeting)
	t = table.table
	assert_equal [[1,"hello"],[2,"bonjour"],[3,"guten tag"]],t
	puts table
#assert_equal
end
def test_map
	table = Table.new.tabulate(h = {:a => 1,:b => 2, :c => 3} ).headers(:letter,:number)

	t = table.table
	assert_equal 3,table.rows
	assert_equal 2,table.columns
	assert_equal h.to_a,t
	puts table
end
def test_2d_array
	table = Table.new.tabulate(h = {:a => 1,:b => 2, :c => 3}.to_a ).headers(:letter,:number)
	t = table.table
	assert_equal 3,table.rows
	assert_equal 2,table.columns
	assert_equal h,t

	table = Table.new.tabulate(h.transpose ).headers(:one,:two,:three)
	t = table.table
	assert_equal 2,table.rows
	assert_equal 3,table.columns
	puts table
end

def test_show_nil
	table = Table.new.tabulate(h = {"nil" => nil}).show_nil("XXXX")

	assert_equal "nil,XXXX",table.to_s
end

def test_wrong_headers
	table = Table.new.tabulate(h = {:a => 1,:b => 2, :c => 3}).headers(:letter)
	begin
		table.table
		fail "expected exception for wrong headers"
	rescue; end
	table = Table.new.tabulate(h = {:a => 1,:b => 2, :c => 3}.to_a.transpose ).headers(:letter)
	begin
		table.table	
		fail "expected exception for wrong headers"
	rescue; end

end
end
