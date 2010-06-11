#crud viewer with fields

require 'view_mapper'

class ObjectViewer

	attr_accessor :fields, :actions, :viewer_map

	def fields_for(object)
		obj.methods.find_all{|it| 
			m = it + "="
			if obj.methods.include?(m) then
				if obj.method(it).arity == 0 and obj.method(m).arity == 1 then
					true
				end
			end
		}	
	end
	def initialize(object, mapper)
		@object = object
		fields_for(@object).each{|it|
			value = @object.method(it).call
			mapper.create(value)
		}
	end

end

