class WebView
attr_accessor :members,:view
def initialize (view)
	@view = view
	@members = []
end
def link
	s = ""
	if @view.is_action? then
		s << "<div><a href='/?ID=#{@view.parent.object_id}&call=#{@view.name}'>#{@view.name}</a></b></div>\n"
	else
		s << "<div><a href='/?ID=#{@view.object_id}'>#{@view.name}</a></b></div>\n"
	end
	s
end
	def input(map = {},append = "")
		map = {:type => "text",
			:class => "nudy_editable",
			:id => @view.parent.object_id,
			:name => @view.name,
			:value => @view.get
			}.merge(map)
		s = "<input "
		map.each {|key,value| s << " #{key.to_s}=\"#{value.to_s}\" "}
		s << append << " />"
	end

def html
		s = ""
	if @view.has_members? then
		if @view.is_field? then
			s << "#{@view.name}="
		else
			s = "#{@view.title}:#{@view.object_id}"	

		end
		
		s << "\n<div class='nudy_form' id=#{@view.object_id} style='padding-left:50;'>\n"
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
			s << "<div> #{@view.name}:#{input(:value => @view.get)}</div>\n"
		end
	end
	s 
end


end
