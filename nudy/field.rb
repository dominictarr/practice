
require 'nudy/viewable'
class Field < Viewable
	attr_accessor :name
	def initialize (parent,name)
	@parent = parent
	@name = name
	end
	def get
		@parent.method(@name).call
	end
	def set(n_value)
		@parent.method("#{@name}=").call(n_value)
	end
	def field_type
		#you could hard-wire this,
		#or make a dynamic type
		#might be better to subclass field for cases like 'reference'
		#	- then the field points to another object. you should search for one of those objects, rather than edit the one it points to.
		@parent.method(@name).call.class
	end
end
