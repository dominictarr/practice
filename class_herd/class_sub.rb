module ClassHerd
class ClassSub 

def initialize
	@map = Hash.new
end

def setSub (klass,klass2)
		@map.store(klass, klass2)
end

def sub (klass,*args,&block)
	if @map.has_key?(klass) then
	x = @map.fetch(klass)
	return x.new(*args,&block)
	end#if
	return klass.new(*args,&block)
end

end
end