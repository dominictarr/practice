  # myapp.rb
require 'sinatra'
#require 'nudy/web/web_object_view'
require 'nudy/web2/web_view'
class WebBuilder
attr_accessor :id2web

def initialize 
#@field_types = [WebOptions,WebBoolean,WebField,WebObjectField,WebObject]
#@field_types = [WebField,WebObjectField,WebObject]
	@id2web = Hash.new
end
def self.default_builder 
	WebBuilder.new
end
def find_web_viewer(object)
	t = @field_types.find {|f| f.handles?(object)}
	t.new(object,self)
end
def new_web_view(view)

end
def build(view)
	if id2web[view.object_id] then
		return id2web[view.object_id]
	else
		web = WebView.new(view)
		id2web[view.object_id] = web
		#add members.
		if view.has_members? then
			view.members.each{|m|
				web.members << build(m)	
			}
		else
			puts "!#{view}.has_members?"
		end
		web
	
	end
end
end
