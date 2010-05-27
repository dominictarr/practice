#module Module
#redefine class comparison methods

#end

require 'monkeypatch/class2'
require 'class_herd/class_copier'
require 'class_herd/class_references4'


module ClassHerd
module ClassConductor3
	def _on(x)
		x2 = ClassCopier.new.copy(x)
		#x2 = x.dup
		#x2.send(:instance_variable_set, :@duped,x)
		x2.send(:instance_variable_set, :@replacements,[])
		#x.send(:include,ClassHerd::ClassConductor3)
		x2.send(:extend,ClassHerd::ClassConductor3)
#	x.append_features(ClassHerd::ClassConductor3)
#	x.class_eval("include ClassHerd::ClassConductor3")
#		x.send(:define_method,self.module_function(:replace))
		#x.send(:define_method,module_method(:on))
	end
	def _replace(x,y)
		@replacements << [x,y]
		const_set(x, y)
		self
	end	
	def _rewires
		#get all constants which map to classes which are reffs
		map = Hash.new
		r =ClassReferences4.new
		r.parse(self)
#		puts "#{self}._rewires = \n#{constants.inspect}=>#{r.reffs.inspect}"
		constants.each{|const|
			klass = const_get(const)
			if Class === klass and 
				r.reffs.include? const.to_sym then
				map[const.to_sym] = klass
			end
		}
		map
	end
end
end
