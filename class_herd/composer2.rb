require 'yaml'
require 'class_herd/rewirer'


module ClassHerd
class Composer2
	def initialize (array)
		@name = array[0]
		#@klass = eval(@name)
		if array.length == 2 then
			@map = array[1]
		end
	end
	def using 
		eval @name
	end
	def classes
		if @classes.nil? then
			r = Rewirer.new
			r.for(using)
			@classes = r.klass
			#use a library to store Composer2's 
			#for each array.object_id
			#~ @map.each{|sym,klass|
				#~ if Array === klass then
					#~ r.replace(sym,klass.classes)
				#~ else
					#~ r.replace(sym,eval(klass))
				#~ end
			#~ }
		end
			@classes

	end
	def create (*args,&block)
		classes.new(*args,&block)
	end

end;end