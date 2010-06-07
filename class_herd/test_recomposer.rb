
require 'monkeypatch/TestCase'
require 'class_herd/test_rewirer'
require 'class_herd/recomposer'

module ClassHerd
class TestRecomposer < Test::Unit::TestCase
include Test::Unit
def chtr(name)
	"ClassHerd::TestRewirer::#{name}"
	end

def test_simple
	comp = [chtr(:Rak),{:Lom => [chtr(:Zax)],
					:Ras => [chtr(:Kiki)]}]
	rcomp = Recomposer.new(comp).recompose("HelloThere",:Lom)
	assert_equal [chtr(:Rak),{:Lom => ["HelloThere"],
					:Ras => [chtr(:Kiki)]}],rcomp
end

def test_2_layer
	comp = ["Klass", {:Definition => ["LiteralDefinition", {:Term => ["STUFF"]}]}]
	rcomp = Recomposer.new(comp).recompose("THINGS",:Definition,:Term)
	assert_equal ["Klass", {:Definition => ["LiteralDefinition", {:Term => ["THINGS"]}]}], rcomp

	rcomp = Recomposer.new(comp).recompose("THINGS",:Definition)
	assert_equal ["Klass", {:Definition => ["THINGS"]}], rcomp
end

def test_cmd
	comp = ["Klass", {:Definition => ["LiteralDefinition", {:Term => ["STUFF"]}]}]
	rcomp = Recomposer.new(comp).recompose_cmd("Definition=>Term=>THINGS")
	assert_equal ["Klass", {:Definition => ["LiteralDefinition", {:Term => ["THINGS"]}]}], rcomp

	rcomp = Recomposer.new(comp).recompose_cmd("Definition=>THINGS")
	assert_equal ["Klass", {:Definition => ["THINGS"]}], rcomp

	puts comp
	begin
		rcomp = Recomposer.new(comp).recompose_cmd("Definition=>Term=>THINGS")
		fail ("expected an error to occur")
	rescue; end

end
end;end
