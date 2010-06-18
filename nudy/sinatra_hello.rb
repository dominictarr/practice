  # myapp.rb
  require 'rubygems'
  require 'sinatra'
  require 'nudy/web_builder'

	#application layers:
	#---------------
	#domain layer (defines the problem space)
	#interface layer (defines how an interface should behave, without making a commitment to any particular sort of interface)
	#user interface layer (implementation of an actual interface)
	#~~~~~~~~~~~(screen)
	#user (human/monkey/etc)
	#setup interface layer

def setup
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
end

def html (contents)

"<html><body> #{contents}</body></html>"

end
factory = WebFactory.new
viewer = factory.build(setup)

  get '/' do
		if params["ID"] then
			viewer = ObjectSpace._id2ref(params["ID"].to_i).viewer
			params.each{|key,value|
				unless key == "ID" then
					b = viewer.member(key)
					if b then
						b.set(value)
					else
						puts "#{viewer} did not have member named: #{key}"
					end
				end
			}
			html factory.build(viewer).view
			
		else
			html viewer.view
		end
  end

not_found do
    'This is nowhere to be found'
  end
error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
  end

