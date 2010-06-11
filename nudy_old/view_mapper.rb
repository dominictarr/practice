
require 'object_viewer'

class ViewMapper
	attr_accessor :map
	def initialize(map)
		@map = map
	end
	def create(object, mapper = self)
		m = @map[object.class]
		if m then
			m.new(object,mapper)
		else
			ObjectViewer.new(object,mapper)
		end
	end
end
