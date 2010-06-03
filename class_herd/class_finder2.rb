require 'monkeypatch/array'

module ClassHerd
class ClassFinder2
	attr_accessor :ref
	
	def from_symbol_module_parent(klass, sym)
		parent = klass.name.split("::")[0..-2].join("::")
		if parent != "" then
			parent_klass = klass.module_eval(parent)
			from_symbol_module(parent_klass, sym)
		end
	end
	def from_symbol_module(klass, sym)
		begin
			x = klass.module_eval(sym.to_s)
			return x
		rescue
			return from_symbol_module_parent(klass, sym)
		end
	end
	def from_symbol(klass,sym)
		@ref = sym.to_s
		if klass.nil? then
			eval sym.to_s
		else
			x = nil 
			klass.ancestors.find {|a|
				x = from_symbol_module(a,sym)
			}
			x
		end
	end
end;end