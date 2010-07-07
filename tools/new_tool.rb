class NewTool < Wee::Component
attr_accessor :tool_list
def initialize 
	@tool_list = []
	@type = ""
	@description = ""
end

def new_tool(tool_type,description)
	t = Tool.new
	t.type = tool_type
	t.description = description
	@tool_list << t
end

def render (r)
	puts 
	r.div {
		r.h2 "enter new tool"
		r.form.enctype_multipart.with {
			r.label "tool type:"
			r.text_input.callback {|type| @type = type
				puts "type"
				} 
			r.label "tool description:"
			r.text_input.callback {|description| @description = description
				 puts "description"} 
#			r.select_list(wheres).selected (@where).callback {|selected| self.where=selected}
		r.submit_button.callback {|c|
			new_tool (@type,@description)
			 puts "submit" 
		}
		}

	}
end
end
