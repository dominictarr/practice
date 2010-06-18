  # myapp.rb
  require 'rubygems'
  require 'sinatra'
  get '/' do
	
    s = "" << 'Hello world - from sinatra!'
	s << params.inspect
	s 
	s
  end

not_found do
    'This is nowhere to be found'
  end
error do
    'Sorry there was a nasty error - ' + env['sinatra.error'].name
  end


