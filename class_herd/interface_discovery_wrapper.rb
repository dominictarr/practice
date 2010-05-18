require 'monkeypatch/class2'


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

	#def make_alias (klass,method,&block)
        #idw = self
        #klass.send(:alias_method, :"idw_#{method}", method)
        #klass.send(:define_method, method,&block)
      	#end

	def initialize
	@interface = Hash.new
	@instances = Hash.new
	@idw = self
	end

	def wrap_method (klass,method)
	idw = self
	klass.send(:alias_method, :"idw_#{method}", method)
	#m = klass.instance_method("idw_#{method}".to_sym)
	#puts "#{klass}=>#{method}"
	klass.send(:define_method, method){|*args,&block|
                	puts "METHOD=>#{method}"
                	m = idw_method("idw_#{method}".to_sym)
                     	r = m.call(*args,&block)
                	#puts idw
			idw.interface(klass) << method
               		r
		 }
	end

	def wrap (klass)
        k = Class.new(klass)
 #	k = klass.dup
        k.send(:instance_variable_set, :@duped,klass)
	wrap_method(k,:method)
	m = k.instance_methods - #+ k.private_methods - 
		["idw_method","method"]
	#(k.instance_methods - ["idw_method","method"])
	m.each{|method|
		wrap_method(k,method.to_sym)
	}
	wrap_method(k,:initialize)
	k
	end

	def instances(klass)
		a = []
		ObjectSpace.each_object(klass){|k| a << k}
		a
	end

end;end
