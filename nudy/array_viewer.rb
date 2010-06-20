
require 'nudy/viewer'
class ArrayViewer < Viewer


def get_field(name) #it could be a subclass of array, which means it could have some attr(=) fields.
		if name.is_a? Integer then
			@object[name]
		else
			@object.method(name).call
		end
end
def is_array?
	return @object.is_a? Array
end

def set_field(name,object)
	if name.is_a? Integer then
		@object[name]=object
	else
		@object.method("#{name}=").call(object)
	end
end

#question here, is how to handle viewers? stick the object into the array, and create a new field around it?
#yeah, it has to be like that, because the viewer could be from somewhere else. and not designed to go into an array...
def insert(index,object)

end

def remove(index)

end

end
