require 'yaml'
require 'class_herd/rewirer'

module ClassHerd
class Composition2
	attr_accessor :map	
	def == (other)
		begin
			map.eql?(other.map) and using.eql?(other.using)
		rescue NoMethodError => e
			false
		end
	end
	def eql? (other)
		self == other
	end
	def initialize (to_use = nil,lib = nil)
		#this extracts the composition from to_use.
		@map = Hash.new
		lib ? @library = lib : @library = Hash.new
		if to_use then
			load_wiring(to_use)
		end
	end
	def all_classes
			@library  || @library = Hash.new
	end
	def load_wiring(to_use)
		use(to_use)

		to_use._wiring.each {|sym,klass|
			if klass._reffs.empty? then
	#			puts "load: #{klass}"
				replace (sym,klass)
			else
	#			puts "load2: #{klass}"
				#raise "recursive opperation not supported"
				if all_classes[klass.object_id]  then
					k =  all_classes[klass.object_id] 
				else
					k =  Composition2.new(klass,@library)
					all_classes[klass.object_id] = k
				end
				replace (sym,k)
			end
		}
	end

	def use(klass); 
		if @use.nil? then
			@use = klass.name
			self
		else
			Composition2.new(nil,@library).use(klass)
		end
	end
	def using 
		eval(@use)
	end
	def replace(sym,klass)
		if !(using._reffs.include? sym) then
			raise "cannot replace #{sym.inspect} => #{klass.inspect}. #{@use} does not use #{sym.inspect}"
		end
		if Class === klass then
		@map[sym] = klass.name
		elsif Composition2 === klass then
			@map[sym] = klass
		else
			raise "klass must be a class. #{klass} not yet supported" 
		end
		self
	end
	#~ def rewire(a_map)
		#~ r = Rewirer.new
		#~ r.for(eval(a_map[:use]))
		#~ (a_map.keys - [:use]).each{|it|
			#~ klass_name = a_map[it]
			#~ if Hash === klass_name then
				#~ klass = rewire(klass_name)
			#~ else
				#~ klass = eval(klass_name)
			#~ end
			#~ r.replace(it,klass)
		#~ }
		#~ r.klass
	#~ end
	def classes
		if @classes.nil? then
			r = Rewirer.new
			r.for(using)
			@classes = r.klass
#		puts "new version of: #{using}"
			@map.each{|sym,klass|
#				puts "#{key} => #{@map[key]}"
				if Composition2 === klass then
					
				r.replace(sym,klass.classes)
			else
				r.replace(sym,eval(klass))
			end
		}
#		puts r.klass.inspect
		end
			@classes
	end
	def create (*args,&block)
		classes.new(*args,&block)
	end
	alias_method :old_to_yaml, :to_yaml
	def to_yaml
		@classes = nil
		@library = nil
		old_to_yaml
	end
end;end
