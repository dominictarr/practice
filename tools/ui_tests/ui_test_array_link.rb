require 'tools/ui_tests/ui_test'
require 'tools/wee/array_link_wee'

class UiTestArrayLink < UiTest

def initialize 
  super
 @component = ArrayLinkWee.new
end
def wants_handler_for_class
   Array
end
  def random_list (n, l = 5)
	letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	words = []
	n.times {
	  word = ""
	  l.times {
	  	word << letters[rand(26)]
	  }
	  	word << rand(10).to_s
	  words << word
	}
	words
  end
def list (array)
 @list = array
 @component.handle(array)
 @component.callback {|c| @chosen = c}
end
def choose (x)
  step ("choose \'#{x}\'",@component) {
#	puts "@chosen == " @chosen
	  @chosen == x
	}
end
def choose_random(l,n)
  list r = random_list(l)
  n.times {choose r[rand(l)]}
end

def description
  "this is a component for selecting members from relatively short lists"
end

def all_steps
  prompt_next(false)
  list ['hello', 'goodbye', 'sayoonara', 'bonjour', 'lebewohl', 'houdy', 'guten tag']
  choose 'sayoonara'
  choose 'guten tag'

  list (1...36).to_a

  choose 17
  choose 5

  choose_random(10,4)
  choose_random(30,3)

  list [Class, Object, Array, String, Hash, Kernel, Module]

  choose @list[rand(@list.length)]
  choose @list[rand(@list.length)]

end
end

Wee.runcc(UiTestArrayLink, :server => :Mongrel) if __FILE__ == $0

