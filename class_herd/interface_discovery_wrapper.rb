require 'monkeypatch/class2'
require 'monkeypatch/array'

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
	@idw = self
	end

	def wrap_method (klass,method)
	idw = self
	klass.send(:alias_method, :"idw_#{method}", method)
	klass.send(:define_method, method){|*args,&block|

                	m = idw_method("idw_#{method}".to_sym)
                     	r = m.call(*args,&block)
			unless idw.interface(klass).include? method then
				idw.interface(klass) << method
			end
               		r
		 }
	end

	def wrap (klass)
      #  k = Class.new(klass)
	k = klass.dup

        k.send(:instance_variable_set, :@duped,klass)
	wrap_method(k,:method)
	m = k.instance_methods - #+ k.private_methods - 
		["idw_method","method"]
	#(k.instance_methods - ["idw_method","method"])
	m.each{|method|
		wrap_method(k,method.to_sym)
	}
	#wrap_method(k,:initialize)
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
	
	puts "k2:" + i.inspect
        puts "k1:" + (k1.instance_methods & i).inspect
	puts "k1.instance_methods" + k1.instance_methods.inspect 
	
	puts k1.instance_methods.sub_set?(i)
		k1.instance_methods.sub_set?(i)
	end
end;end
