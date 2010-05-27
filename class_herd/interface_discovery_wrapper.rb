require 'monkeypatch/class2'
require 'monkeypatch/array'
require 'class_herd/class_copier'

module ClassHerd
class InterfaceDiscoveryWrapper
	
	def wrapped?(x)
		unless x.is_a? Class then
			raise "InterfaceDiscoveryWrapper.wrapped?(x) should be called with a Class, but was :#{x}"
		end
		if x.is_duplicated? then
			x = x.duped
		end
		
		return !(@interface[x].nil?)
	end
	
	def interface(x)
		unless x.is_a? Class then
			raise "InterfaceDiscoveryWrapper.interface(x) should be called with a Class, but was :#{x}"
		end
		if x.is_duplicated? then
			x = x.duped
		end
		
		if @interface[x].nil? then 
			@interface[x] = []
		end
		@interface[x]
	end
	alias_method(:idw_special_interface, :interface)
	#def instances(x)
        #        if @instances[x].nil? then
        #                @instances[x] = []
        #        end
        #        @instances[x]
        #end

	def initialize
	@interface = Hash.new
	@instances = Hash.new
	@copier = ClassCopier.new
	@idw = self
	end
	def make_args (arity)
		args = []
		var = nil
		if(arity == 0)
			return "&block"
		elsif (arity < 0)
			var = "*args"
			arity = (arity + 1) * -1
		end
		arity.times{|i| args << "arg#{i}"}
		if var then args << var; end
		args << "&block"
		return args.join(",")
	end

	def wrap_method (klass,meth)
	#method_method = klass.instance_method(:idw_special_method)
	#check if meth is a special method
	if meth.to_s =~ /^idw_special_.*$/ then 
	#	puts "DIDN'T WRAP SPECIAL"
	return; 
	#else	
	#puts "wrapped :#{ meth}"
	end
	#args = make_args(klass.method(:"idw_#{meth}").arity)
	args = make_args(klass.instance_method(meth).arity)
	klass.send(:alias_method, :"idw_#{meth}", meth)

	#~ klass.send(:define_method, meth){|*args,&block|
		#~ #redo this using eval and producing matching arity value.
         		#~ m = method("idw_#{meth}".to_sym)
                     	#~ r = m.call(*args,&block)
			#~ idw_special_add_method(meth)
			#~ r
		 #~ }

	klass.class_eval("def #{meth} (#{args})
				idw_special_add_method(:#{meth})
				return method(\"idw_#{meth}\").call(#{args});
	end")

	if(klass.instance_method(meth).arity != klass.instance_method("idw_#{meth}").arity) then
		raise "error, wrapped method.arity not equal to original arity!"
	end
end

	def wrap (klass)
	if (klass.method_defined? :idw_special_wrappers) then
		k = klass
		k.send(:class_variable_get,:@@idw_wrappers) << self
		   if !(k.send(:class_variable_get,:@@idw_wrappers).include? self) then
                	raise "instance variable didwnt work"
		puts k.send(:class_variable_get,:@@idw_wrappers).inspect
	        end
#raise "trying to double wrap #{klass}"
		return k
	end

	#k = klass.dup
	k = @copier.copy(klass)
	puts "	IDW.wrap(#{klass}) => #{k}"
	idw = [self]
	k.send(:class_variable_set,:@@idw_wrappers,[self])
       	if([self] != k.send(:class_variable_get,:@@idw_wrappers)) then
		raise "instance variable didwnt work"
	end
	
	k.send(:define_method, :idw_special_wrappers){idw}
	#~ k.send(:define_method, :idw_special_add_method){|meth|
		#~ k.send(:class_variable_get, :@@idw_wrappers).each{|idw|
		   #~ unless idw.idw_special_interface(k).include? meth then
                          #~ idw.idw_special_interface(k) << meth
                   #~ end
		#~ }
	#~ }
	k.class_eval( "def idw_special_add_method (meth)
	#puts \"		\#{meth.to_s} <--- \#{self.class}.add_method()\"
		@@idw_wrappers.each{|idw|
	#puts \"*\" 
			unless idw.idw_special_interface(self.class).include? meth then
				idw.idw_special_interface(self.class) << meth
			end
		} end")
        k.send(:alias_method, :idw_special_method, :method)
        k.send(:instance_variable_set, :@duped,klass)
	#wrap_method(k,:method)
	m = k.instance_methods - # k.private_methods - 
		(["idw_method","method","class"] + Object.methods)
	#(k.instance_methods - ["idw_method","method"])
	m.each{|method|
		wrap_method(k,method.to_sym)
	}
	k
	end

	def instances(klass)
		a = []
		ObjectSpace.each_object(klass){|k| a << k}
		a
	end

	def is_compatible? (k1,k2)
		#~ if interface(k2).empty? then 
			#~ raise "InterfaceDiscoveryWrapper doesn't know anything about #{k2}. 
			#~ can't say if #{k1} is compatible with #{k2}.
			#~ must be one of: #{@interface.keys.inspect}
			#~ #{k2}.is_duplicated? = #{k2.is_duplicated?}
			#~ #{k2}.duped = #{k2.duped}
			#~ interface(#{k2.duped}) = #{interface(k2).inspect}

			#~ it's only empty because no methods have been called on it. IDW knows that. fix this.
			#~ "
		#~ end
	unless wrapped?(k2) then 
		raise "is_compatible(k1,k2) needs a k2 where wrapped?(k2) == true. was: wrapped?(#{k2}) = false"; 
	end
	puts "is_compatible?(#{k1},#{k2})" 	
	i = interface(k2).collect {|m| m.to_s}
	
	#puts "k2:" + i.inspect
        #puts "k1:" + (k1.instance_methods & i).inspect
	#puts "k1.instance_methods" + k1.instance_methods.inspect 
	
	#puts k1.instance_methods.sub_set?(i)
		k1.instance_methods.sub_set?(i)
	end
end;end
