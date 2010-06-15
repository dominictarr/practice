

require 'rubygems'
require 'fox16'
require 'nudy/action'
require 'nudy/reference'
require 'nudy/field'
require 'nudy/viewable'
require 'nudy/interface_builder2'

require 'nudy/attr_member_builder'
require 'nudy/options_member_builder'

	require 'nudy/fox_object_display'
	include Fox

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
	#application layers:
	#---------------
	#domain layer (defines the problem space)
	#interface layer (defines how an interface should behave, without making a commitment to any particular sort of interface)
	#user interface layer (implementation of an actual interface)
	#~~~~~~~~~~~(screen)
	#user (human/monkey/etc)
	#setup interface layer

	ib = InterfaceBuilder2.new
	opt = OptionsMemberBuilder.new(Options)
	ref = AttrMemberBuilder.new(Reference,Person)
	ref.builder = ib
	ib.add(opt,ref,AttrMemberBuilder.new(Field))
	#ib.add(ActionMemberBuilder.new(Action,:methods,:clone))
	ib.map(Object,Viewable).mask << :taguri
	
	p = Person.new
	p.another_person = Person.new.randomize
	p.another_person.name = 'gorge'
	p.another_person.another_person = Person.new

	o = ib.build(p)

	application = FXApp.new("Hello", "FoxTest")
	main = FXMainWindow.new(application, "Hello", nil, nil, DECOR_ALL)

	FoxFactory.viewer(main,o)
	#since the GUI layer fairly directly matches the field layer, it's builder is simple.

	application.create()
	main.show(PLACEMENT_SCREEN)
	application.run()

