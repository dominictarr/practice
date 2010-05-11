class Class
alias_method :class_conductor_aliased_new,  :new
#if someone else has hooked and given it the same alias a bad thing will happen.

	@duped = nil

	 def new(*args, &block)
		if $ClassConductor then
		return $ClassConductor.create(self, *args, &block)
		else
		return class_conductor_aliased_new(*args, &block)
		end
	end
	
end