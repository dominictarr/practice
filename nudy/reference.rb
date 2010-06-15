require 'nudy/viewable'
require 'nudy/field'
require 'nudy/interface_builder2'
class Reference < Field
	attr_accessor :builder
 	def initialize (parent,name)
		puts "REFERENCE! #{name}"
		super(parent,name)
	end

	def viewer
		unless @builder then
			raise "#{self} was not assigned an #{InterfaceBuilder2} instance"
		end
		return @builder.build(get)
	end
end
