#class conductor using symbol shadowing
#~ #two ways to reconfigure:
#~ #1.
#~ #replace (X,Y)
#~ #means: always use Y in the place of X globally.
#~ #2.
#~ #for(A).replace(B,C)
#~ #means: A now uses C instead of B
#~ #3.
#~ #[for(A)].replace(B,C).when {test is true}...

#~ #could monkey patch Class instead of going For(x) might be a better idea not to though.

#~ #implemention approch:

#~ #1. hook X.new to return a new Y
#~ #1.2. or reassign :X to point to Y?
#~ #2. C shadow B on A.
#~ #3. B' shadow B on A, hook B'.new to eval test and return C.new if it passes, else super.

#stacking.
#for(A).replace(B,for(C).replace(X,Y))
#means in A, use a C (which uses Y instead of X) instead of B
#will need a terminator:
#for(A).replace(B,for(C).replace(X,Y).do).do

#or to reverse the syntax
#replace(B,replace(X,Y).on(C)).on(A)
#thats slightly more confusion.
#if for(A) returns A.dup, and the replace modify that...
#then, when things are stacked, it will work automagicially.

#to use the configuration: call new on the top level dup.
#probably best to avoid calling replace() globally.

#~ #how might a test framework use this?
#~ #For(Test).replace(StandardSubject, NewSubject)
#~ #by duplicating Test, could create a list of all Test combinations.

#~ #this would also allow a elegant configuration definition

#~ [AppleTree #for class AppleTree
	#~ [Apple : Pear]#replace Apple with Pear
	#~ [Roots : Pipes, {test}] #use rockets for roots when test is true.
	#~ [Trunk : [ModularTrunk 
		#~ [Stem : Stem1]
		#~ [Branch: Branch3]]]
#~ ]

#~ #since we've made settings for ModularTrunk under Trunk, that applies only in that situation.
#~ #implement this my shadowing AppleTree.trunk with ModularTrunk.dup 
	
#~ what about application composition? (with reference to tests?)
	
#~ it will be like the above, but will say 'passes(Test1,Test2,Test3)' 
#~ what about tests which refur to more than one class?
#~ can use this to detect which classes are compatable - they can pass the test when used together...
#~ this must be what they mean by *integration tests*...
module ClassHerd

class ClassHerd::ClassConductor2
	attr_accessor :klass
	def self.for(x)
		ClassConductor2.new(x)
	end
	@klass
	def initialize(x)
		@klass = x.dup
	end
	def replace(x,y)
		@klass.const_set(x, y)
		self
	end	
	
	def create (*args,&block)
		@klass.new(*args,&block)
	end
		
end
end
