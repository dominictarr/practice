require 'wee'
require 'nudy/any_builder'
require 'tools/tool'
require 'tools/new_tool'
require 'tools/member'

class ToolBox < Wee::Component

attr_accessor :tools,:members

def initialize
	puts "initialize!"
	@tools = []
	@members = []
	@current = nil
#	tools = AnyBuilder.new.klass(Tool).table(:name,%w{hammer saw axe lazer screw_driver}).build
	%w{hammer saw axe lazer screw_driver}.each{|n|
	tools << t = Tool.new
		t.type = n
	}
	@tools << n = NewTool.new
	n .tool_list = @tools
	
	%w{dominic darren simon sam jacob ed}.each{|n|
	members << t = Member.new
		t.name = n
		t.phone = 123
		t.email = "exec@makerspace.org.nz"
	}
end

def children
	@current ? [@current] : []
	#must define children for callbacks to get through.
end

def select (tool)
	#puts "select"
	@current = tool
end
def render_list(r, list, name, &block)
	r.ol{
		list.each{|t|
			r.li { 
			r.anchor.callback(&block.call(t)).with(t.method(name).call)
			}
		}
	}
end

def render (r)
	r.div.with {
		render_list(r,tools,:type){|t| proc {self.select (t)}}
		render_list(r,members,:name){|t| proc {self.select (t)}}
	}
	r.div {r.render(@current)} if @current #this is first problem i've found. 
	#r.div {@current.render(r)} if @current
	#the cause wasn't a bug. it was that I didn't def children.
end

end


Wee.run(ToolBox, {:server=>:Mongrel}) if __FILE__ == $0
