  # myapp.rb
require 'sinatra'
require 'nudy/web/web_object_view'
require 'nudy/web/web_viewers'
class WebFactory

def initialize 
@field_types = [WebOptions,WebBoolean,WebArray,WebField,WebObjectField,WebObject]
end

def find_web_viewer(object)
	t = @field_types.find {|f| f.handles?(object)}
	t.new(object,self)
end

def build(object)
	WebObjectView.new(object,object.members.collect{|c| 
		find_web_viewer (c)
	})
end
end
