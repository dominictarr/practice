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
	def of (klass)
		klass._wiring
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
		r.for(eval(a_map[:use]))
		(a_map.keys - [:use]).each{|it|
			klass_name = a_map[it]
			if Hash === klass_name then
				klass = rewire(klass_name)
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
	def of (klass)
		#build a new composition from the structure of a given class
		

	end
end;end
