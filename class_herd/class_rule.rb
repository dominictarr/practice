
module ClassHerd

	class ClassRule 
		attr_accessor :name
		
		def initialize (name)
			@name = name
		end

	#returns true if this rule applies in this situation.
	def check (klass)
	end

	def wrap? (obj)
		return test?(obj) && @wrap != nil
	end

	def wrap (&block)
		@wrap = Proc.new(&block)
	end
	
	def dowrap (obj)
		@wrap.call(obj)
	end

	def test (&block)
		@test = Proc.new(&block)
	end
	def trim_args(func,*args, &block)
		if func.arity >= 1  then arity = func.arity  - 1
		else arity = args.length  end
		
		func.call(*args[0..arity],&block)
	end

	
	def test? (obj, *args, &block)
		begin
		@test == nil || trim_args(@test, obj, *args, &block)
		rescue Exception=>e
			puts "test #{@test} failed for #{obj} in ClassRule #{self}"
			puts "gave error:#{e}"
		end
	end

	def replace (from, to)
		@from = from
		@to = to
	end
	
	def replace? (f)
		if(f == @from) then
			@to
		else
			nil
		end
	end
	end
end