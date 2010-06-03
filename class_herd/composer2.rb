require 'yaml'
require 'class_herd/rewirer'

module ClassHerd
class Composer2
	def initialize (array,lib=nil)
		@name = array[0]
		@library = lib || Hash.new
		@library [array.object_id] = self
		#@klass = eval(@name)
		if array.length == 2 then
			@map = array[1]
		end
	end
	def using 
		eval @name
	end
	def get_class(array)
		if @library[array.object_id] then
			@library[array.object_id].classes #returns a Composer2
		else
			Composer2.new(array,@library).classes
		end
	end
	def classes
		if @classes.nil? then
			r = Rewirer.new
			r.for(using)
			@classes = r.klass
			#use a library to store Composer2's 
			if @map then
				@map.each{|sym,array|
					r.replace(sym.to_s,get_class(array))
				}
			end
		end
			@classes

	end
	def create (*args,&block)
		classes.new(*args,&block)
	end

end;end