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
def self.is_one?(klass, *classes)
	classes.find{|f| klass <= f}
end
def self.handles? (object)
	puts "#{self} handles #{object.class} #{object.field_type
		}"

	return ((!(object.methods & ["name","get"]).empty?) and is_one?(object.field_type, String, Numeric,TrueClass,FalseClass))
	
end
def view; "#{@field.name}='#{@field.get.inspect}'\n" end
def name; @field.name end
def value; @field.get end
end

class WebObjectField < WebField
def self.handles? (object)
	puts "#{self} handles #{object.inspect}"
	return (!(object.methods & ["name","get"]).empty? and !WebField.handles?(object))
end
def value; "<a href=/?ID=#{@field.object_id}>#{@field.get.class}:#{@field.object_id}</a>" end
end

class WebArray < WebField #displaying arrays is a serious job.
def self.handles? (object)
	puts "#{self} handles #{object.inspect}"
	return (!(object.methods & ["name","get"]).empty? and object.field_type == Array)
end
def value 
	ol = "<ol>\n"
	@field.get.each{|e|
		ol << "\n<li>#{e}</ti>\n"
	}
	ol << "<ol>\n"
#	"<a href=/?ID=#{@field.object_id}>#{@field.get.class}</a>" end
	ol
end
end
