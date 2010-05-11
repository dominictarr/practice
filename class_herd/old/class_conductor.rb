require "monkeypatch/class"
require "class_herd/class_rule"

module ClassHerd

	class ClassHerd::ClassConductor
		attr_accessor :rules
		
		def initialize 
		@rules = []
		end
	
		#check if there is a rule for klass apply it, otherwise, initilize  klass normally
		
		def create(klass, *args, &block)
			#puts caller
			c = klass
			#go through rules
			#ask each replace? klass

			if(@rules)
				@rules.each { |r| 
					x = r.replace?(klass)
					if x && r.test?(klass,*args,&block) then c = x end}
			end

			if(!c.is_a?(Class)) then
				raise "ClassConductor asked to init something which isn't a class: #{c}"
			end
			
			obj = c.class_conductor_aliased_new(*args,&block)
			
			if(@rules)
				@rules.each {|r| if r.wrap?(obj) then obj = r.dowrap(obj) end}
			end
			obj
		end
		
		#later, we might want to store multiple class conductors in a stack...
		def activate
			$ClassConductor = self
		end
		def deactivate
			$ClassConductor = nil
		end
		
		def newrule(name)
			r = ClassRule.new(name)
			@rules << r
			r
		end
	end
end