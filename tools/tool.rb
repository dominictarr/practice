require 'wee'
require 'tools/tool_event'

class Tool < Wee::Component
  attr_accessor :type,:description,:owner,:where,:changes

def wheres
	[:stored,:in_use,:borrowed,:misplaced,:lost]
end

def initialize
	@type = "Tool"
	@description = "Default Tool Description"
	@where = :stored
	@changes = []
end

def where=(s)
	unless wheres.include? s then
		raise "invalid where #{s} for #{self}"
	else
		if s != where then
			puts changes.inspect
			changes.insert(0, ToolEvent.new(self,@where,s))
			@where = s
		end
	end
end

def render (r)
	puts 
	r.div {
		r.h2 type
		r.paragraph description
		r.paragraph "is:" + @where.to_s
		r.form.enctype_multipart.with {
			r.select_list(wheres).selected (@where).callback {|selected| self.where=selected}
		r.submit_button
		}
#		r.ul {
#		wheres.each{ |w|
#		   r.li{
 # 			r.anchor.callback{self.where=w
#			puts "callback:#{w}"
#			}.with(w)
#		   }
#			}
#		}
		r.table{
			@changes.each{|e|
				r.render(e)
			}
		}
	}
end

end


Wee.run(Tool, :server=>:Mongrel) if __FILE__ == $0
