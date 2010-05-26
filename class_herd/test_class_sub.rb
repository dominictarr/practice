require 'test/unit'
require 'class_herd/class_sub'

module ClassHerd
#~ lets try for a class substitutor
	
#~ it may be that it's better to do this by editing the code, before it's compiled.

#~ will try both methods, and see what works...

#~ i'm sure editing the code will have it's own problems anyway...

#~ subsitutor will have a map of classes,
#~ and will intercept Class.new and return an instance of a different class instead.

#~ capibilities to decide what class to return?
#~ sub(Klass, &block) ...aslong as it takes the right arguments...?
#~ the block can decide what to do, 
	#~ whether it really wants to change the class
	#~ depending on what function it was created in... use stacktrace...

	#~ ...strip out stack information above the caller of klass.new... so the substitutor class can change 
#~ without confusing the composition.

#~ but, how to give the configuration the trimmed stacktrace?
#~ i know. hook or add a new stacktrace function to kernel (or where ever it is...)

#~ or have a function on the substitutor which can filter the stacktrace, 
#~ and call that when someone calls kernel stacktrace...

class Hello1
def initialize(s)
@name = s
end

def say
	r = "Hello, #{@name}!"
	puts "#{self.class.inspect}.say=>#{r}"
	r
end
end

class Bonjour1 < Hello1
#~ def initialize(s)
#~ @name = s
#~ end
def say
	r = "Bonjour, #{@name}!"
	puts "#{self.class.inspect}.say=>#{r}"
	r
end
end

class TestClassSub < Test::Unit::TestCase 
	
	#hmm. what functions should ClassSub have?
	#setsub(Klass,&block) => returns what class to use instead.
	#  or an instance? - yup
	#(with instances you could do cool stuff like translate error messages)
	#  or a symbol which means use default.  - later
	#sub (Klass) executes the block mapped to klass, or just returns class.

	#speed could be important.

	#ah! sub will have to know when it's initializing something, so that it doesn't try to substitute it again.
	#although, this could be used to extend compositions.

	#but of course, saying instead of this Class X, use a class which passes test TestX

	#but maybe I want to generate the composition when the program starts...
	#so, read the composition (which says Class => Test)
	#and generate Class=> newClass

def test_sub
	cs = ClassSub.new
	name = "Jeremy"
#	puts "x = #{Bonjour1}.new(name)"
	x = Bonjour1.new(name)
	assert_equal "Bonjour, Jeremy!",x.say
	x = Hello1.new(name)
	assert_equal "Hello, Jeremy!",x.say

	cs.setSub(Hello1,Bonjour1)
	
	x = cs.sub(Hello1,"Jeremy")
	assert_equal "Bonjour, Jeremy!",x.say

	cs2 = ClassSub.new
	cs2.setSub(Bonjour1,Hello1)
	
	x = cs2.sub(Bonjour1,"Jeremy")
	assert_equal "Hello, Jeremy!",x.say
end

end#class
end#module
