require 'rubygems'
require 'ramaze'
class MainController < Ramaze::Controller
  def index
    'Hello, World! from ramaze'
  end
 def hello
    "Hello from Another!"
  end
end
Ramaze.start
