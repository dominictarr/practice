require 'ap'

class ViewDef

attr_accessor :types, :viewer, :type_strict, :as_field, :auto_fields, :members 

#minium setttings are:
#viewer, fields or auto_fields = true

#type_strict only makes sense for fields. (because type checking occurs during assignment)

#as_field also, is something which the structure builder deals with.


def set_auto_fields (bool)
	@auto_fields = bool
	self
end
def set_types(*types)
	@types = types 
	self
end
def set_members(*members)
	@members = members
	self
end
def set_type_strict(bool)
	@type_strict = bool
	self
end
def set_viewer(viewer)
	@viewer = viewer
end
def set_as_field(as_field)
	@as_field = as_field
end
def is_typed?
	!@types.nil? and !@types.empty?
end 
def handles? object
	if is_typed? then
		@types.find{|t|
			if t.is_a? Class then
				object.is_a? t
			elsif t.is_a? Proc then
				t.call(object)
			end
		}	
	else
		true
	end
end
def auto_fields (object)

	m = object.methods
	m.select {|f| !(f =~ /^=+/) and m.include? "#{f}="}
end
def members_for(object)
	f = @members || []
	if @auto_fields then
		f = f + auto_fields (object)
	end
	#if @members then
	#	f = f + @members
	#end
	if @mask then
		f = f - @mask
	end
	f
end

def field_types (object)
	ms = member_names (object)
	ms.collect {|m|
		[m, object.method(m).call]
	}
	#...now, how to deal with actions?
end

def build object
	if handles? object then
		v = @viewer.new (object)
		if type_strict then
			v.types = types
		end
		v
	else
		raise "#{self} does not support #{object}"
	end

end
end
