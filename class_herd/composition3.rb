require 'yaml'
require 'monkeypatch/class2'

module ClassHerd
class Composition3
	attr_accessor :library, :ary, :map
	def initialize(lib = nil)
		@library = lib || Hash.new
#		if Class === struct then
#			use(struct)
#		elsif Array === struct then
#			raise "createing composition from Array unsupported"
#		end
	end
	def defaults(*defaults)
		defaults.each{|d|
			if Class === d then
				#add default elements to the library
				#so that it isn't parsed further.
				@library[d.object_id] = [d.name]
			else
				raise "defaults passed item which is not a Class: #{d}"
			end
		}
		self
	end
	def read(struct)
#		if @inited then return; end
#		@inited = true;
#		struct = using
			if Class === struct then
			##begin
			use(struct)
			struct._wiring.each{|sym,klass|
		#		get_array(klass)
		#		replace(sym,Composition3.new(,@library))
			replace(sym,get_array(klass))
		}
			##rescue Exception => e
			##	raise "error when composing #{struct.inspect} : #{e}"
			##end
		end
		self
	end
	def get_array (klass)
		@library[klass.object_id] || Composition3.new(@library).read(klass).ary
	end
	def use(klass)
		if @ary.nil? then
			l = @library[klass.object_id]
			if l.nil? then 
				@library[klass.object_id] = self
				@ary = [klass.name]
			else
#				@ary = @library[klass.object_id] 
				raise "cannot recompose #{klass} \nCompositon3 don't want classes which area already mapped"
			end
			self
		else
			Composition3.new(@library).use(klass)
		end
	end
	def using 
		if @ary.nil? then nil  else eval @ary[0] end
	end
	def for_class(klass)
		k = @library[klass.object_id]
		if k.nil? then 
			@library[klass.object_id] = Composition3.new(@library).use(klass)
			@library[klass.object_id] .ary
		else
			k.ary
		end
	end
	def replace(sym, klass)
		if @map.nil? then
			@ary << @map = Hash.new
		end
		if Composition3 === klass then
			@map[sym] = klass.ary
		elsif Array === klass
			@map[sym] = klass
		elsif Class === klass
			@map[sym] = for_class(klass)
		end
		self
	end
	def == (other)
		begin
			#@map == other.map and
			#@ary == other.ary and
			#@library. == other.library
			composition.to_yaml == other.composition.to_yaml 
		rescue NoMethodError => e
			false
		end
	end
	def eql? (other)
		self == other
	end
	def composition
		@ary
	end
end;end
