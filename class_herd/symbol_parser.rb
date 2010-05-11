 require 'sexp_processor'

class SymbolParser < SexpProcessor

	attr_accessor :result

	def initialize
		super
		self.strict = false
		end

	def add(ary)
		if @result == nil then @result = ary; 
			else @result << ary; end
		end
		
	def handle_class_name(exp)
		name = exp.shift
		if name.nil? then
			return nil
		elsif(!(Symbol === name)) then
			return SymbolParser.new.parse(name)
		end
			return [:const, name]
	end
	def process_class(exp)
	
		sym = exp.shift
		name = handle_class_name(exp)
		superclass = handle_class_name(exp)
		sp = SymbolParser.new
		sp.add [sym, name, superclass]

		r = s(:class, name, superclass, sp.parse(exp.shift))
		if sp.result != nil && sp.result.length > 0  then add sp.result; end
			return r
	end

	def handle_colon2(exp)
		sym = exp.shift
		if sym == :const then
			return [:const, exp.shift]
		elsif sym == :colon2
			#	(sym == :colon2) then
			ary = handle_colon2(exp.shift) #inner sexp's
			return ary << exp.shift #name
		else
			raise "Expected :colon2 or :const but found #{sym}"
		end
	end
	def process_colon2(exp)
		s = handle_colon2(exp)	
		add s
			return s(*s)
	end

	def process_const(exp)
		sym = exp.shift
		name = exp.shift
		add [sym, name]
		return  s(sym, name)
	end

	def parse(exp)
		if exp.nil? then
			raise "parse(nil): cannot parse nil"
		end
		#~ if !(exp.is_a? Sexp) then
			#~ exp = Sexp.from_array(exp)
			#~ end
			puts "PARSE(EXP) START:" + exp.inspect + "<PARSE(EXP) END:"
			process(exp)
		return @result
	end
end