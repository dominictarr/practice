
module ClassHerd
class ClassReferenceParser
	attr_accessor :name, :super_class, :reffs, :innerclasses
def ref (x,allow_nil = false)
		if x.nil? then
			if allow_nil then
				return nil
			else 
				raise "expected a class reference but found #{x.inspect}"
	end;end
		s = x.shift
		if s != :const then
			raise "expected [:const, (symbols....)]\n" + 
				"but found #{([s] + x).inspect} \n"
		end
		return x
	end

def handle_class (x)
	if x.first == :class then
		return 
	else
		return nil
	end
end

def initialize(x)
	if x.first != :class  then
		raise "expected :class, but found: #{x}"
	end
	x.shift
	@name = ref x.shift
	@super_class = ref x.shift, true
	
	@reffs = []
	@innerclasses = []
	x.each{|it|
		if(it.first == :class) then
			@innerclasses << self.class.new(it)
		else
			r = ref(it)
			if !(@reffs.include? r) then @reffs << r; end
		end
	}
end

def nname (x, j='::')
	if x.nil? then
		return nil
	elsif !x.is_a? Array then
		x.inspect
	else	
		return x.join(j)
	 end
end

def nlist (x,lable=">>")
	 n = nname(x.collect {|c| nname(c)},',')
	 if(n && x.length > 0)
		lable + n #+ " :" +  x.inspect
	 end
end
def inspect
	 "[class: #{nname(@name)} < #{nname(@super_class)}{#{nlist(@innerclasses,"\n	innerclasses:")}#{nlist(@reffs,"\n	references:")}}]"
end

end;end