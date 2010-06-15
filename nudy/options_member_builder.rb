require 'nudy/attr_member_builder'

class OptionsMemberBuilder < AttrMemberBuilder

	def handles? (owner,name)
		super(owner,name) and has_method(owner,"#{name}s")
	end
end
