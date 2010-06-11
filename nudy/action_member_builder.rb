class ActionMemberBuilder
		attr_accessor :target, :names, :builder
	def initialize(target, *names)
		@target = target
		@names = names.empty? ? nil : names.collect {|c| c.to_s}
		@builder = nil
	end
	def check_types(obj)
		@types.find {|f| f. === obj}
	end
	def check_arity(owner,member,n)
		unless has_method(owner,member) then return false; end
		arity = owner.method(member).arity
		#ap "#{arity} == #{n}"
		arity == n or (arity < 0 and (arity + 1) * -1 <= n)
	end
	def has_method(owner,method)
		owner.methods.include? method.to_s
	end
	
	def handles? (owner, member)
		member = member.to_s
		check_arity(owner,member,0) and @names.nil? ? true : @names.include?(member)
	end
	def build (owner,member)
		t = target.new(owner,member)
		if @builder and has_method(t,:builder) and check_arity(t,:builder,1) then
			t.builder(@builder)
		end
		t
	end
end
