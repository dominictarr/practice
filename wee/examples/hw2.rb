$LOAD_PATH.unshift "../lib"
require 'rubygems' if RUBY_VERSION < "1.9"
require 'wee'

class HelloWorld < Wee::Component
 def initialize
   super
   add_decoration Wee::PageDecoration.new(title="Hello World")
 end

 def render(r)
   r.h1 "Hello World from Wee!"
   r.div.onclick_callback { p "clicked" }.with("click here2")
 end
end

Wee.run(HelloWorld) if __FILE__ == $0
