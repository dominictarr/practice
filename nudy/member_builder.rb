

class AttrMemberBuilder
		attr_accessor :target, :types, :builder
	def initialize (builder, target = Field, *types = [String,Fixnum,Integer,Float,Bignum])
		@target = target
		@types = types
		@builder = builder
	end

	def self.check_arity(owner,member,n)
		unless has_method(owner,member) then return false; end
		arity = owner.method(member).arity
		arity == n or (arity < 0 and (arity + 1) * -1 <= n)
	end
	def self.has_method(owner,method)
		owner.methods.include? method
	end
	
	def handles (owner, member)
		check_arity(owner,member,0) and
		check_arity(owner,"#{member}=",0) and 
		types.inclued? owner.method(member).call 
	end
	def build (owner,member)
		t = target.new(owner,member)
		if @builder and has_method(t,:builder) and check_arity (t,:builder,1) then
			t.builder(@builder)
		end
		t
	end
end
