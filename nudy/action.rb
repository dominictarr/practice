
require 'nudy/viewable'

class Action < Viewable
	attr_accessor :name
	def initialize (parent,name)
	@parent = parent
	@name = name

	end

	def call
		#if returns parent object or nil, then update display
		#if it returns a different object, 
		#open a viewer for that object.
		# ???
		r = @parent.method(@name).call
		update
		r
	end
end
