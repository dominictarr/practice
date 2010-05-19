
#require 'primes/TestPrimes'
#require 'test_class_rule'
#require 'test_class_sub'
require 'sexp_processor'
require 'class_herd/parser'
require 'class_herd/class_finder'

module ClassHerd
class ClassReferences4 < SexpProcessor
	attr_accessor :name, :super_class, :reffs, :sexp
	
	def default_class(symb)
		@finder.from_symbol(@target,symb)
	end	
	def initialize ()
		@reffs = []
		@finder = ClassFinder.new
		super
		unsupported=[]
	end
	def parse(klass)
		@target = klass
		@sexp = Parser.parse_class(klass)
		sexp = Parser.parse_class(klass)
		#sexp.dup#only duplicates the first layer.
		#need a tree_dup method.
		#puts "PARSE:" + @sexp.inspect
		process(sexp)
	end
	def parse_name(exp)

		if Symbol === exp then
			return exp; end
			
		n = exp.shift
		if(n == :const) then
			n = exp.shift
		end

		return n
	end
	def process_class (exp)
		#puts "UNSUPPORTED=#{unsupported.inspect}"
	        #@unsupported =[]
  	
		class_sym = exp.shift
		if class_sym != :class then
			raise "ClassReferences4 expected :class but found #{class_sym}"
		end
		
#		if @name.nil? then
			@name = parse_name(exp.shift)
			@super_class = parse_name(exp.shift)

#		puts "#{@name } < #{@super_class}"
#		else
#			ClassReference4.new.
#		end
		
		code = s(:class, @name, @superclass)

		while exp.length > 0 do
			sexp = exp.shift
#			puts "defn's:" + sexp.inspect
			code << process(sexp)
		end
		return code
	end

	def process_const (exp)
		r = parse_name(exp)
		unless @reffs.include? r then
			@reffs << r
		end
#		puts "REFERENCE: #{r} , #{@reffs.inspect}"
		return s(:const, r)
	end
end;end
