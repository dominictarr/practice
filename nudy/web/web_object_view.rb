class WebObjectView
attr_accessor :viewer
def initialize(viewer,members)
	@viewer = viewer
	@members = members
end

def view
	s ="<h2>#{viewer.title}:#{viewer.object_id}</h2>\n"
	#puts @members.inspect
	#@members.each{|e| s << e.view}
	s << view_vertical
end

def table_row array, indent=""
	"#{indent}<tr>\n\t#{indent}<td>#{array.join("</td>\n<td>")}\n#{indent}</td></tr>"
end

def table (array)
#header = "<table><tr>\n\t<td>#{names.join("</td>\n<td>")}\n</td></tr>"
#values = "<tr>\n\t<td>#{values.join("</td>\n<td>")}\n</td></tr></table>"

#check if it's two leveled

if array.find{|e| !(e.is_a? Array)} then
	"<table> #{table_row array} </table>"
else
tab = "<table>\n"
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
