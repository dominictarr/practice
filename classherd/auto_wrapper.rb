
class Class
alias_method :auto_wrapper_old_new,  :new
#if someone else has hooked and given it the same alias a bad thing will happen.

	 def new(*args, &block)
		if $Auto_wrapper then
		return $Auto_wrapper.wrap(auto_wrapper_old_new(*args, &block))
		else
		return auto_wrapper_old_new(*args, &block)
		end
	end
end

module ClassHerd

class ClassHerd::AutoWrapper 
	def initialize(klass)
		@klass = klass
		@list = []
		@subwrapper = nil
	end
	def on?
		@on 
	end
	def on
		@on = true
		$Auto_wrapper = self
	end
	def off
		@on = false
		$Auto_wrapper = nil
	end

#what if i want test different AutoWrapper classes?
#how can I use an  AutoWrapper  to test it self?
#if the AutoWrapper is not created in this function, it's okay to wrap it self.

#~ if your testing the TestAutoWrapper class,
#~ a new AutoWrapper will be created and will be wrapped in a VCR.
#~ the VCR's won't be double wrapped, unless they checked who wrapped them.
#~ two autowrappers won't be able to wrap the same thing, unless they have a way to 
#~ keep aliased Class.new methods in a stack, or 

def wrap(obj)
		if obj.is_a?(@klass) then
			return obj
		else
		#unless obj is a @klass -> otherwise you'd get infinite recursion
		puts "WRAPPING" + obj.inspect
		x = @klass.new(obj)
		@list << x
		x
		end
	end
	
	def list
		@list
	end
end
end
