
module ClassHerd
class ClassFinder
	attr_accessor :ref
	def from_symbol_module(klass,sym)
		puts "<#{klass}>"
		puts "ANCESTORS: #{ klass.ancestors.inspect}"
		x = nil
		klass.ancestors.each{|klass|
			x = klass.name.split("::")[0..-2]
			unless x.nil? then
				from_symbol(eval(x.join("::")),sym)
			end
		}
			if x.nil? then
				raise "could not find class for symbol #{sym} from #{klass}"
			end
		end
	def from_symbol(klass,sym)
			@ref = sym.to_s
		if(klass.nil?) then 
			begin
				return eval @ref ; 
			rescue
				raise "could not find class for #{sym}"
			end
		end
		begin
			return klass.class_eval(@ref )
		rescue 
			return from_symbol_module(klass,@ref )
		end
	end
end;end
