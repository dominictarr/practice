module ClassHerd
class Recomposer

#take input sym, sym, sym, classname
#look for symbols recursively, and if wvncounter 

def initialize (comp)
	@composition = comp
end
def get (comp,*sym)
	begin
		if sym.length == 1 then
			r = comp[1][sym.first.to_sym]
			unless r then raise "could not find symbol #{sym.to_sym} in #{comp[1].inspect}" end
			return r
		else
			get(comp[1][sym.first.to_sym],*sym.tail)
		end
	rescue Exception => e 
	raise "expected #{comp.inspect} to have {#{sym.first.to_sym.inspect} => ...} \n\t...got error #{e}"
	end
end

#two types of recomposing. 
#pointer recomposing - only the pointer is recomposed i.e. 
#address recomposing - every thing which points to the same array is recomposed.

#currently this only implements address.. 

#but all I intend to use this for is running a different class in a test.
#so this is sufficant.
def recompose_cmd(cmd)
	c = cmd.split("=>")
	#puts c.inspect
	#puts c.last.inspect
	#puts c[0..-2].inspect
	recompose(c.last, *c[0..-2])
end

def recompose(klass, *mapping)
	get(@composition,*mapping).clear << klass
	@composition
end
end;end
