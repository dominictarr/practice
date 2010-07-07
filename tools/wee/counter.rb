require "monkeypatch/module"
require "rubygems"
require "wee"

class Counter < Wee::Component
quick_attr :value
def state (s)
	s.add_ivar(self,:@value, @value)
end
def render(r)
	@value = 0 if @value.nil?
	r.div {
		r.anchor.callback {@value = @value - 1}.with "-"
		r.label @value
		r.anchor.callback {@value = @value + 1}.with "+"

	}
end
end


Wee.runcc(Counter, :server => :Mongrel) if __FILE__ == $0 

