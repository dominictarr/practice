require 'yaml'
require 'class_herd/rewirer'

module ClassHerd
class Composer
	attr_accessor :map
	def initialize (klass)
		@map = {:use => klass.name}
	end
	def use(klass); end
	def replace(sym,klass)
		if Class === klass then
		@map[sym] = klass.name
		elsif Composer=== klass then
			@map[sym] = klass.map 
		else
			raise "Composition cannot remap a class to a #{klass.inspect}"
		end
		self
	end
end
class Composition
	attr_accessor :map
	def initialize (map = nil)
		@map = map
	end
	def use(klass); 
		u = Composer.new(klass)
		if @map.nil? then
			@map = u.map
		end
		u
	end
	def rewire(a_map)
		r = Rewirer.new
		r.for(eval(@map[:use]))
		(@map.keys - [:use]).each{|it|
			klass_name = @map[it]
			if Composer === klass_name then
				klass = rewire(klass.map)
			else
				klass = eval(klass_name)
			end
			r.replace(it,klass)
		}
		r.klass
	end
	def classes
		rewire(@map)
	end
	def create (*args,&block)
		classes.new(*args,&block)
	end
end;end
