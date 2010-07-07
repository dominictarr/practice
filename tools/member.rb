require 'wee'

class Member < Wee::Component

attr_accessor :name, :email, :phone


def list_attr(r,*attrs)
	r.ul do
	attrs.each{|i|
	   r.li "#{i}: #{method(i).call}"
	}
	end

end 
def render (r)

	r.h2 name
	list_attr(r,:email,:phone)
end

end
