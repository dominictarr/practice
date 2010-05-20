#module Module
#redefine class comparison methods

#end

require 'monkeypatch/class2'
require 'class_herd/class_copier'

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
end
end
