  require 'rubygems'
  require 'sinatra'
  require 'nudy/web2/nude_web_app'
  require 'nudy/examples/person'

def setup 
	p = Person.new
	p.another_person = Person.new.randomize
	p.another_person.name = 'billy'
	p.another_person.another_person = Person.new
	p
end


#supply class webapp as composition file. 
#no! supply domain model & 
domain_root = setup
builder = ViewBuilder.default_builder(
	ViewBuilder.new(ViewDef.new.
			set_viewer(Viewer).
			set_types(Person).
			set_members(['randomize',nil,'refresh'],['dup',nil,'open']).
			set_auto_fields(true).set_as_field(false)
	)
)
set :root, root = File.dirname(__FILE__)
set :public, Proc.new { File.join(root, "web2/public") }

nude = NudeWebApp.new(domain_root,builder)

  get '/update' do
	puts "AKKKS"
	nude.update(params)
  end

  get '/' do
	nude.get(params)
  end

not_found do
    'This is nowhere to be found'
  end
error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
  end


