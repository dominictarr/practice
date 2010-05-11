
require 'primes/TestPrimes'
require 'test_class_rule'
require 'test_class_sub'
require 'class_reference_parser'
require 'symbol_parser'
require 'ruby_parser'

module ClassHerd
class ClassReferences

	MAP = Hash.new
	MAP[TestPrimes] ="./primes/TestPrimes.rb"
	MAP[TestClassRule] ="./test_class_rule.rb"
	MAP[TestClassSub] ="./test_class_sub.rb"

#later, I will make a way to get the parsing of a class 
#(it will be easy with ParseTree, but not compatable with ruby 1.9)

	def initialize (klass)
		
		if MAP[klass].nil? then 
			raise "ClassReferences needs hardcoding for #{klass} or rewriting to be dynamic"
		end
		#puts MAP[klass]
		parser = ClassReferenceParser.new(
			SymbolParser.new.parse(
				RubyParser.new.parse(
						File.open(MAP[klass]).read)))
	end

	def reffs
		parser.reffs
	end
end;end