class WebView
attr_accessor :members,:view
def initialize (view)
	@view = view
	@members = []
end
def link
	s = ""
	if @view.is_action? then
		s << "<div class='nudy_link' #{id}><a href='/?call=#{id}'>#{@view.name}</a></b></div>\n"
	else
		s << "<div class='nudy_link' #{id}><a href='/?view=#{id}'>#{@view.name}</a></b></div>\n"
	end
	s
end
	def input(map = {},append = "")
		map = {:type => "text",
			:class => "nudy_editable",
			:id => "field_" + id,
			:name => @view.name,
			:value => @view.get
			}.merge(map)
		s = "<input "
		map.each {|key,value| s << " #{key.to_s}=\"#{value.to_s}\" "}
		s << append << " />"
	end
def id (view = @view)
	 "#{view.object_id.to_s(16)}_id"
end
def html
		s = ""
	if @view.has_members? then
		s << "\n<div class='nudy_form' id=#{id}>\n"
		if @view.is_field? then
			s << "#{@view.name}="
		else
			s = "#{@view.title}:#{id}"	
		end
		
		s << "\n"
		@members.each{|m|
			if m.view.has_members? and !m.view.is_a? ArrayViewer then
				s << m.link
			elsif m.view.is_action? then
				s << m.link
			else
				s << m.html
			end
		}
		s << "</div>\n"
	elsif @view.is_field? then
		if [String,Numeric,TrueClass,FalseClass,NilClass].find {|f| f <= @view.object.class} then
			s << "<div class='nudy' nudy_id=#{id} id=#{id}> #{@view.name}:#{input(:value => @view.get)}</div>\n"
		end
	end
	s 
end


end
