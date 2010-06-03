
#require 'primes/TestPrimes'
#require 'test_class_rule'
#require 'test_class_sub'
require 'sexp_processor'
require 'class_herd/parser'
require 'class_herd/class_finder'

module ClassHerd
class ClassReferences4 < SexpProcessor
	attr_accessor :name, :super_class, :super_class_name, :reffs, :sexp
	
	def ref_classes
#		puts "!!!>:#{reffs.inspect}"
		reffs.collect {|s|
		default_class(s)
		}
	end

	def default_class(symb)
		begin
			c = @finder.from_symbol(@target,symb)
		rescue Exception => e
			raise "#{self.class} couldn't find the class for symbol=> #{symb}\n#{e}"
		end
	end	
	def initialize ()
		@reffs = []
		@finder = ClassFinder.new
		super
		@unsupported=[]
	end
	def parse(klass, parse_duped = false)
	
		if klass.is_duplicated? and !parse_duped then
#			puts "parsing duplicated class"
			klass = klass.original_class
		end
		@target = klass
		@sexp = Parser.parse_class(klass)
		sexp = Parser.parse_class(klass)
		#sexp.dup#only duplicates the first layer.
		#need a tree_dup method.
		#puts "PARSE:" + @sexp.inspect[0,100]
		process(sexp)

	#clean up symbols.
		@reffs = @reffs.select{|s|
			Class === default_class(s)
		}	
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
			@super_class_name = parse_name(exp.shift)
			@super_class = @finder.from_symbol(@target,@super_class_name)

#		puts "#{@name } < #{@super_class}"
#		else
#			ClassReference4.new.
#		end
		
		code = s(:class, @name, @superclass)

		while exp.length > 0 do
			sexp = exp.shift
			
			#puts "defn's:" + sexp.inspect
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
