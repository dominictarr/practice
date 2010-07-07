

class ToolEvent < Wee::Component

def was
	@was
end
def became
	@became
end
def at
	@time.to_s
end
def tool
	@tool
end
def initialize (tool,was, became)
	@tool = tool
	@was = was
	@became = became
	@time = Time::now
end

def render (r)
#	r.paragraph
	r.table_row{
		r.table_data at
		r.table_data was
		r.table_data became
	}
end

end
