

class AttrMemberBuilder
		attr_accessor :target, :types, :builder
	def initialize(target, *types)
		@target = target
		@types = types.empty? ? [Object] : types
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
		#ap owner
		#ap member

		#ap "#{check_arity(owner,member,0)} and #{check_arity(owner,"#{member}=",1)} and #{@types.include? owner.method(member).call.class}"
		#ap @types
		check_arity(owner,member,0) and
		check_arity(owner,"#{member}=",1) and 
		check_types(owner.method(member).call)
	end
	def build (owner,member)
		t = target.new(owner,member)
		if @builder and has_method(t,:builder) and check_arity(t,:builder,1) then
			t.builder(@builder)
		end
		t
	end
end
