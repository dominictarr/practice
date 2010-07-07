class Module

def quick_attr (*args)
	args.each {|ivar|
	send :define_method, :args, proc {|arg = nil|
		send (:instance_variable_get, ivar) if arg.nil? 
		send (:instance_variable_set, ivar, arg)
		self
	}
	}
end
end
