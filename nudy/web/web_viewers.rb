class WebObject
def initialize (field,factory)
	@field = field
	@factory = factory
end
def self.handles? (object)
	puts "#{self} handles #{object.inspect}"
	true
end
def view
	"#{@field.inspect}<br>\n"
end
def name
	@field.class
end
def value
	@field.object_id
end
end

class WebField < WebObject
	def self.is_one?(klass, *classes); classes.find{|f| klass <= f} end
	def self.types; [String, Numeric] end

	def self.handles? (object)
		((!(object.methods & ["name","get"]).empty?) and is_one?(object.field_type, *types))
	end
	def view; "#{@field.name}='#{@field.get.inspect}'\n" end
	def name; @field.name end
	def input(map = {},append = "")
		map = {:type => "text",
			:class => "nudy_editable",
			:name => name,
			:value => @field.get
			}.merge(map)
		s = "<input "
		map.each {|key,value| s << " #{key.to_s}=\"#{value.to_s}\" "}
		s << append << " />"
	end
	def value; input end
end
class WebBoolean < WebField
	def self.types; [TrueClass,FalseClass] end
	def value; input ({:type => :checkbox}, @field.get ? "checked" : "") end
end

class WebObjectField < WebField
	def self.handles? (object)
		return (!(object.methods & ["name","get"]).empty? and !WebField.handles?(object))
	end
	def value
		if @field then
			viewer_id = @field.viewer.object_id
			puts "	viewer!:#{viewer_id}"
			"<a href=/?ID=#{viewer_id}>#{@field.get.class}:#{viewer_id}</a>"
		else
			"<b>nil</b>"
		end
	end
end

class WebOptions < WebField
	def self.handles? (object)
		return (object.methods & ["name","get","options"]).length == 3
	end
	def value
		if @field then
			"<b>#{@field.options.inspect}</b>"
		else
			"<b>nil</b>"
		end
	end
end


class WebArray < WebField #displaying arrays is a serious job.
	def self.handles? (object)	
		return (!(object.methods & ["name","get"]).empty? and object.field_type == Array)
	end
def value 
	ol = "<ol>\n"
	@field.get.each{|e|
		ol << "\n<li>#{e}</ti>\n"
	}
	ol << "<ol>\n"
	ol
	end
end
