

class PrimitiveViewer
#viewer for String's, Number's
#does not display any sub_fields.
	def initialize(parent,name, mapper)
		@name = name
		@parent = parent
	end
	def get
		@parent.method(name).call
	end
	def set(newvalue)
		@parent.method(name + '=').call(newvalue)
	end

end
