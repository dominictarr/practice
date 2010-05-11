require 'test/unit'
require 'class_sub_block'

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

class ClassHerd::TestClassSubBlock < Test::Unit::TestCase 
	
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
	cs = ClassSubBlock.new
	cs.setSub(String) {|i| i.to_f}
	
	x = cs.sub(String,"15.4")
	assert_equal (15.4,x)
	
	cs.setSub(Integer) {|i| i.to_s}
	y = cs.sub(Integer,36)
	assert_equal ("36",y)
end

end#class
end#module