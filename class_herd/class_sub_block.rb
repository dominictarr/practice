module ClassHerd
class ClassHerd::ClassSubBlock

def initialize
	@map = Hash.new
end

def setSub (klass,&block)
		@map.store(klass, Proc.new (&block))
end

def sub (klass,*args,&block)
	if @map.has_key?(klass) then
	x = @map.fetch(klass)#(*args,&block) 
	return x.call(*args,&block)
	end#if
	return klass.new(*args,&block)
end

end
end