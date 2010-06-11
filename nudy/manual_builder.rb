

require 'rubygems'
require 'fox16'
require 'nudy/action'
require 'nudy/field'
require 'nudy/object_viewer'
require 'nudy/interface_builder'

class Person
attr_accessor :name,:age,:sister,:height,:programmer,:male, :shopping,:liar,:another_person
def initialize 
	@name = "bob"
	@sister = "jenny"
	@age = 21
	@height = 175.23
	@programmer = true
	@male = true
	@liar = false
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
	#@shopping = ['eggs','milk','cheese','bread', 'bacon','etc']
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
	p = Person.new
	p.another_person = Person.new.randomize
	p.another_person.name = 'gorge'
	o = ObjectViewer.new(p)
	def fields (parent,*fields)
		fields.collect{|f|
			Field.new(parent,f.to_s)
		}
	end

	defaults = InterfaceBuilder.new
	defaults.add(Field,Fixnum,Float,Integer,String,TrueClass,FalseClass)
	ib = InterfaceBuilder.new(defaults)
	ib.add(ObjectViewer,Person).add_fields(:name,:age,:height,:programmer,:liar,:another_person).add_actions("randomize")
	o = ib.build(p)

	require 'fox_object_display'
	include Fox

	application = FXApp.new("Hello", "FoxTest")
	main = FXMainWindow.new(application, "Hello", nil, nil, DECOR_ALL)

	FoxFactory.viewer(main,o)
	#since the GUI layer fairly directly matches the field layer, it's builder is simple.

	application.create()
	main.show(PLACEMENT_SCREEN)
	application.run()

