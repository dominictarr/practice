require 'nudy/view_builder'
require 'nudy/web2/web_builder'
#  require 'nudy/web_builder'
require 'nudy/view_builder'
require 'nokogiri'

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
def style
	"<style> .nudy, .nudy_form,.nudy_link {padding-left:50;}
		.nudy_content {
		width:400;
		}
		</style>\n"
end
def id2viewer (id)
	puts 'parse:' + id
	if id =~ /.*?_id/ then
		 ObjectSpace._id2ref(id.sub("_id","").to_i(16))
	end
end
def id (view)
	 "#{view.object_id.to_s(16)}_id"
end
def update(params)
	updated = "update:"
	builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
		xml.root do 
			params.each{|key,value|
			view = id2viewer(key)
				if view then
					other = id2viewer (value)
					value = other ? other.get : value
					view.set(value)
					updated << "(#{view.name}=#{value})\n"
					xml.item(value,:id => id(view), :name => view.name)
				end
			}
		end
	end
	puts toxml = builder.to_xml
	toxml
#	'updated'
end
def get(params)
	#update if necessary,
	#redisplay.
	web_view = @web_view
	if params["view"] then
		obj = id2viewer(params["view"]) 
		web_view = obj ? @web_builder.build(obj) : @web_view
	end
	if params["call"] then
		#m =  web_view.view.member(params["call"])
		m = id2viewer(params["call"])
		r = m ? m.call : nil
		if r.is_a? Viewer then
			puts "OPEN OR REFRESH!"
			web_view = @web_builder.build(r)
		
		end		
	end
	"<html><head>#{js}#{style}</head><body><div class='nudy_content'>#{web_view.html}</div></body></html>"
end
end
