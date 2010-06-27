
#require 'rubygems'

#require 'nudy/action'
#require 'nudy/reference'
#require 'nudy/field'
#require 'nudy/viewable'
#require 'nudy/options'
#require 'nudy/interface_builder2'

#require 'nudy/attr_member_builder'
#require 'nudy/options_member_builder'

#require 'nudy/web/web_factory'
#require 'sinatra'

class Person
attr_accessor :name,:age,:sister,:height,:programmer,:male, :shopping,:liar,:another_person,:option
def initialize 
	@name = "bob"
	@sister = "jenny"
	@age = 21
	@height = 175.23
	@programmer = true
	@male = true
	@liar = false
	@option = nil
	@shopping = ['eggs','milk','cheese','bread', 'bacon','etc']
end
	def chop
		self.height= self.height/2

		self
	end

	def randomize
		@age = 1 + rand(100)

		@height = 100 + rand * 100
		@programmer = rand(1) == 1
		@male = rand(2) == 1
		@liar = rand(2) == 1
		self
	end
	def options 
		return @shopping
	end
end

