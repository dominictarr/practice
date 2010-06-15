require 'nudy/viewable'
require 'nudy/reference'
require 'nudy/interface_builder2'
class Options < Reference
	attr_accessor :options
	def initialize(owner,name)
		puts "OPTIONS"
		super(owner,name)
	end
	def options
		parent.method ("#{name}s").call 
		#this is going to throw strange error messages... make builder for this type which can check?
	end
end
