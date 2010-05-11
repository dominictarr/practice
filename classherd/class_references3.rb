
require 'primes/TestPrimes'
require 'test_class_rule'
require 'test_class_sub'
require 'class_reference_parser'
require 'symbol_parser'
require 'sexp_processor'
require 'parser'
module ClassHerd
class ClassReferences3

#later, I will make a way to get the parsing of a class 
#(it will be easy with ParseTree, but not compatable with ruby 1.9)

	def initialize (klass)
				#puts MAP[klass]
		@parser = ClassReferenceParser.new(
			SymbolParser.new.parse(Parser.parse_class(klass)))
	end

	def reffs
		return @parser.reffs
	end
	def superclass
		@parser.superclass
	end
	def name
		@parser.name
	end
	def innerclasses
		@parser.innerclasses
	end
	def inspect
		@parser.inspect
	end
end;end