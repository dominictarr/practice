require 'test/unit'
require 'nudy/view_def'
require 'nudy/viewer'
require 'nudy/array_viewer'
require 'nudy/view_builder'
require 'nudy/any_builder'

class TestViewBuilder < Test::Unit::TestCase
include Test::Unit

class SomeFields 
	attr_accessor :string,:int,:float,:array,:none
	def initialize
		@string = "hi"
		@int = 36
		@float = 3.141
		@none = nil
		@array = [@string, @int,@float]
	end
end
def test_view_builder
#set and check parent, children,
#check build viewdef.

vd_s = ViewBuilder.new(ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(String))
vd_i = ViewBuilder.new(ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(Integer))
vd_f = ViewBuilder.new(ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(Float))
vd_a = ViewBuilder.new(ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(Array))
#vd_n = ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(proc {|n| n.nil?})
vd_n = ViewBuilder.new(ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(NilClass))

vd_o = ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(Object).set_auto_fields(true)

b = ViewBuilder.new(vd_o,[vd_s,vd_i,vd_f,vd_a,vd_n])
#b = ViewBuilder.new(vd_o,[vd_s,vd_i,vd_f,vd_a])
sf = SomeFields.new
assert_equal "hi", sf.string
view = b.build(sf)

ap view.member("string")
assert_equal view, view.member("string").parent
assert_equal view, view.member("int").parent
assert_equal view, view.member("float").parent
assert_equal view, view.member("none").parent
assert_equal view, view.member("array").parent

assert_equal sf.string, view.member("string").get
assert_equal sf.int, view.member("int").get
assert_equal sf.float, view.member("float").get
assert_equal sf.none, view.member("none").get
assert_equal sf.array, view.member("array").get

assert !view.member("string").has_members?
assert !view.member("int").has_members?
assert !view.member("float").has_members?
assert !view.member("none").has_members?
assert !view.member("array").has_members?

assert_equal [String], view.member("string").types
assert_equal [Integer], view.member("int").types
assert_equal [Float], view.member("float").types
assert_equal [Array], view.member("array").types


end

def test_view_builder_smartly
names = %w{string int float none array}
types = [String,Integer,Float,NilClass,Array]

vds = types.collect{|i|
	ViewBuilder.new(
	ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(i))
}
vd_o = ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(Object).set_auto_fields(true)
b = ViewBuilder.new(vd_o,vds)

sf = SomeFields.new
view = b.build(sf)

[names,types].transpose.each{|n,t|
	assert_equal view, view.member(n).parent
	assert_equal sf.method(n).call, view.member(n).get
	assert !view.member(n).has_members?
	assert_equal [t], view.member(n).types
}
end

#what to test?
#test that correct view_builders are retrived ... buy ancestor_handles?


def test_view_builder_parent
names = %w{string int float none array}
types = [String,Integer,Float,NilClass,Array]

ab = AnyBuilder.new.klass(ViewDef).defaults({:set_viewer => Viewer, :set_type_strict => true}).table(:set_types,types).build
ab << ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(Object).set_auto_fields(true)
vds = ab.collect {|c| ViewBuilder.new(c)}

b = ViewBuilder.new(nil,vds)

sf = SomeFields.new
view = b.build(sf)

assert view.has_members?
tests  = proc {|view|
	[names,types].transpose.each{|n,t|
	assert_equal view, view.member(n).parent
	assert_equal sf.method(n).call, view.member(n).get
	assert !view.member(n).has_members?
	assert_equal [t], view.member(n).types
}}

tests.call(view)

b.children.each{|b_child|
sf = SomeFields.new
view = b.build(sf)
tests.call(view)
}
end
def test_with_array_viewer
names = %w{string int float none array}
types = [String,Integer,Float,NilClass,Array]

ab = AnyBuilder.new.klass(ViewDef).defaults({:set_viewer => Viewer, :set_type_strict => true}).table(:set_types,types - [Array]).build
ab << ViewDef.new.set_viewer(Viewer).set_type_strict(true).set_types(Object).set_auto_fields(true)
ab << ViewDef.new.set_viewer(ArrayViewer).set_type_strict(true).set_types(Array).set_auto_fields(true)
vds = ab.collect {|c| ViewBuilder.new(c)}

b = ViewBuilder.new(nil,vds)

sf = SomeFields.new
view = b.build(sf)

assert view.member('array').has_members?, "expected #{view.member('array')}.has_members? == true"
end



#child_handles?
#ancestor_handles?


end