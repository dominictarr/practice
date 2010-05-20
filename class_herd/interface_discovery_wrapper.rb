require 'monkeypatch/class2'
require 'monkeypatch/array'
require 'class_herd/class_copier'

module ClassHerd
class InterfaceDiscoveryWrapper
	def interface(x)
		if @interface[x].nil? then 
			@interface[x] = []
		end
		@interface[x]
	end
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

	def wrap_method (klass,meth)
	#method_method = klass.instance_method(:idw_special_method)
	#check if meth is a special method
	if meth.to_s =~ /^idw_special_.*$/ then 
	#	puts "DIDN'T WRAP SPECIAL"
	return; 
	#else	
	#puts "wrapped :#{ meth}"
	end
	klass.send(:alias_method, :"idw_#{meth}", meth)
	klass.send(:define_method, meth){|*args,&block|

			#puts "WANTS TO CALL METHOD:#{meth} #{args[0]},#{args[1]}"
			#if(args[0] == "method") then
         		#      puts "WANTS TO CALL METHOD ON METHOD"
         		#end
			#end
			#puts "call idw_special_method(#{args[0]})"
			
			#r = idw_special_method(:"#{args[0]}")
			#elsif (meth.to_s == 'idw_special_method')
  			#puts "WANTS TO CALL METHOD:#{meth} #{args[0]},#{args[1]}"
                      
			#else
	             #          m = idw_method("idw_#{meth}".to_sym)
         			m = method("idw_#{meth}".to_sym)
                     		r = m.call(*args,&block)
			#end
			idw_special_add_method(meth)
		#	unless idw.interface(klass).include? meth then
		#		idw.interface(klass) << meth
		#	end
               		r
		 }
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
	idw = [self]
	k.send(:class_variable_set,:@@idw_wrappers,[self])
       	if([self] != k.send(:class_variable_get,:@@idw_wrappers)) then
		raise "instance variable didwnt work"
	end

	k.send(:define_method, :idw_special_wrappers){idw}
	k.send(:define_method, :idw_special_add_method){|meth|
	#	puts "IDW_WRAPPERS: #{k.send(:class_variable_get, :@@idw_wrappers).length}"
		k.send(:class_variable_get, :@@idw_wrappers).each{|idw|
		
		   unless idw.interface(k).include? meth then
                          idw.interface(k) << meth
                   end
		}
	}

        k.send(:alias_method, :idw_special_method, :method)
        k.send(:instance_variable_set, :@duped,klass)
	#wrap_method(k,:method)
	m = k.instance_methods - #+ k.private_methods - 
		["idw_method","method","class"]
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
		if interface(k2).empty? then 
			raise "InterfaceDiscoveryWrapper doesn't know anything about #{k2}. can't say if #{k1} is compatible with #{k2}"
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
