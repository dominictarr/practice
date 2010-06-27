  require 'rubygems'
  require 'sinatra'
  require 'nudy/web_builder'
  require 'nudy/view_builder'


def setup2 (builders = [])
	p = Person.new
	p.another_person = Person.new.randomize
	p.another_person.name = 'billy'
	p.another_person.another_person = Person.new

	b = ViewBuilder.default_builder(builders)

	b.build(p)
end


  get '/' do
 'HELLO SINATRA!'
#		v = update(params)
#		puts v.inspect
#		if v then
#			web_viewer = factory.build(v)
#			html (web_viewer.view, web_viewer.head)
#		else
#			html(viewer.view,viewer.head)
#		end
  end

not_found do
    'This is nowhere to be found'
  end
error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
  end


