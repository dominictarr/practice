require 'classherd/v_c_r'

module ClassHerd
class VCR2 < VCR

	def initialize (*args, &block)
		super(Object.new(*args, &block))
	end
end;end