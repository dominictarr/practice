require 'nudy/viewable'
require 'nudy/reference'
require 'nudy/interface_builder2'
class Options < Field
	attr_accessor :options,:strict
	def initialize(owner,name)
		puts "OPTIONS"
		super(owner,name)
		@strict = false
	end
	def set (val)
		if @strict and !(options.include? val)then
			raise "#{val} is not one of the options: #{options.inspect}"
		end
		super(val)
	end
	def options
		parent.method ("#{name}s").call 
		#this is going to throw strange error messages... make builder for this type which can check?
	end
end
