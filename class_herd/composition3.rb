require 'yaml'

module ClassHerd
class Composition3
	attr_accessor :library, :ary, :map
	def initialize(struct = nil, lib = nil)
		@library = lib || Hash.new
		if Class === struct then
			use(struct)
			struct._wiring.each{|sym,klass|
				replace(sym,Composition3.new(klass,@library))
			}
		elsif Array === struct then
			raise "createing composition from Array unsupported"
		end
	end
	#~ def from_array(ary)
		#~ unless String === ary[0]  and 
			#~ ((ary.length == 2 and Hash === ary[1]) or ary.length == 1) then 
			#~ raise "array should contain [\"ClassName"
		#~ end
		#~ @ary = ary
		#~ @map = ary[1]
	#~ end
	def use(klass)
		if @ary.nil? then
			l = @library[klass.object_id]
			if l.nil? then 
				@ary = @library[klass.object_id] = [klass.name]
			else
				raise "cannot recompose #{klass}"
			end
			self
		else
			Composition3.new(nil,@library).use(klass)
		end
	end
	def for_class(klass)
		k = @library[klass.object_id]
		if k.nil? then 
			@library[klass.object_id] = [klass.name]
		else
			k
		end
	end
	def replace(sym, klass)
		if @map.nil? then
			@ary << @map = Hash.new
		end
		if Composition3 === klass then
			@map[sym] = klass.ary
		else
			@map[sym] = for_class(klass)
		end
		self
	end
	def == (other)
		begin
			@map == other.map and
			@ary == other.ary and
			@library == other.library
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
