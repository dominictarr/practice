  # myapp.rb
require 'sinatra'
require 'nudy/web/web_object_view'
require 'nudy/web/web_viewers'
class WebFactory

def initialize 
@types = [WebField,WebArray,WebObjectField,WebObject]
end

def find_web_viewer(object)
	t = @types.find {|f| f.handles?(object)}
	t.new(object,self)
end

def build(object)
	WebObjectView.new(object,object.members.collect{|c| 
		find_web_viewer (c)
	})
end
end
