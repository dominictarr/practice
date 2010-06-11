require 'ap'
class InterfaceBuilder2

	class BuildPlan
			attr_accessor :klass,:viewer,:names,:mask,:builder,:member_builders
			def initialize(klass,viewer)
				@klass = klass
				@viewer = viewer
				@builder = nil
				@names = []
				@mask = []
			end
		def masks (d)
			@mask.include?(d.to_sym)
		end
	end

	attr_accessor :member_builder,:mappings,:parent

	def initialize (parent=nil)
	@parent = parent
	@mappings = []
	@members = []
	end


	def map(klass = Object,viewer = ObjectViewer)
		@mappings <<  b = BuildPlan.new(klass,viewer)
		b.builder = self
		b
	end
	def plan(klass)
		@mappings.find{|m| klass <= m.klass}
	end
	def get(klass)
		@mappings.find{|m| klass <= m.klass ? m.viewer : nil}
	end
	def add (*members)
		@members = @members + members
		self
	end

	def build (object)
		p = plan(object.class)
		if p then
			members = []
			object.methods.each {|m|
				unless p.masks(m) then
					@members.find {|mb| mb.handles? (object,m) ? members << mb.build(object,m) : false}
				end
			}
		
			viewer = p.viewer.new(object)
			viewer.builder = p.builder
			viewer.add_members(*members)
			viewer
		elsif @parent
			puts "CALL PARENT.build"
			@parent.build(object)
		else
			puts "NOTHING CAN BE DONE"

		end
	end
end
