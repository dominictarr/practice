require 'nudy/view_builder'
require 'nudy/web2/web_builder'
#  require 'nudy/web_builder'
require 'nudy/view_builder'

class NudeWebApp
attr_accessor :mid_view,:web_view,:id2web, :mid_builder, :web_builder

def initialize (domain, mid_builder =  ViewBuilder.default_builder)
	@mid_builder = mid_builder
	@web_builder = WebBuilder.default_builder
	@mid_view = @mid_builder.build(domain)
	@web_view = @web_builder.build(@mid_view)

	#thinking about redoing the viewers so that it uses by class composition code for configuration.
	#in many ways, this is the perfect first challenge for this idea.
	#it will benefit on being easy replace a class in a certain context.

	#it might be simpler to do it that way:
	#the Class will be like the view_def, but it will just initialize itself.
	#it will need some other object to see what it's in-scope handlers are... a Plugins module? 

	#but for now, I need to learn a bit more about the problem, so i'll continue doing it like this.
end

def js
	"<script type=\"text/javascript\" src=\"js/jquery-1.4.2.js\"></script>\n
	<script type=\"text/javascript\" src=\"js/nudy.js\"></script>\n"
end
def update(params)
	if params["ID"] then
		obj = ObjectSpace._id2ref(params["ID"].to_i)
		if obj.has_members? then
			params.each{|key,value|
			if m = obj.member(key) then 
				m.set value
				puts "#{key}=#{value}"
			end
			}
		end

#		web_view = @web_builder.build(obj)
	end

end
def get(params)
	#update if necessary,
	#redisplay.
	if params["ID"] then
		obj = ObjectSpace._id2ref(params["ID"].to_i)
		@web_view = @web_builder.build(obj)
	end
	if params["call"] then
		m =  @web_view.view.member(params["call"])
		r = m ? m.call : nil
		if r.is_a? Viewer then
			puts "OPEN OR REFRESH!"
			@web_view = @web_builder.build(r)
		
		end		
	end
	"<html><head>#{js}</head><body>#{@web_view.html}</body></html>"
end
end
