class WebObjectView
attr_accessor :viewer
def initialize(viewer,members)
	@viewer = viewer
	@members = members
end

def head
	"<script type=\"text/javascript\" src=\"js/jquery-1.4.2.js\"></script>\n
	<script type=\"text/javascript\" src=\"js/nudy.js\"></script>\n
	"
end

def view
	s ="<h2>#{viewer.title}:#{viewer.object_id}</h2>\n"
	#puts @members.inspect
	#@members.each{|e| s << e.view}
	s << "<form id=\"#{@viewer.object_id}\">\n"
	s << view_vertical
	s << "</form>"
end

def table_row array, indent=""
	"#{indent}<tr>\n\t#{indent}<td>#{array.join("</td>\n<td>")}\n#{indent}</td></tr>"
end

def table (array,name = nil)
#header = "<table><tr>\n\t<td>#{names.join("</td>\n<td>")}\n</td></tr>"
#values = "<tr>\n\t<td>#{values.join("</td>\n<td>")}\n</td></tr></table>"

#check if it's two leveled

if array.find{|e| !(e.is_a? Array)} then
	"<table #{name ? "name=\"#{name}\"" : ""}> #{table_row array} </table>"
else
tab = "<table #{name ? "name=\"#{name}\"" : ""}>\n"
array.each{|row| tab << table_row(row)}
tab << "</table>\n"
end
end

def view_horizontal
names = @members.collect{|e| e.name}
values = @members.collect{|e| e.value}

table [names,values]
end
def view_vertical
names = @members.collect{|e| e.name}
values = @members.collect{|e| e.value}

table [names,values].transpose #rotate
end

end
