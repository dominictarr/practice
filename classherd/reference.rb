module ClassHerd
class Reference
	attr_accessor :symbols
	
	def initialize (x)
	@symbols = []
		s = x.first
		if s != :const then
			raise"Reference inited with wrong args.\n" + 
				"should be: [:const, (symbols....)]\n" + 
				"but found #{x.inspect} \n"
		end
		x.delete_at(0)
		@symbols = x
	end
end
end