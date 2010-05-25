require 'test/unit'
require 'test/unit/testresult'
require 'class_herd/class_references4'
require 'class_herd/class_conductor3'
require 'class_herd/data_for_test'
require 'class_herd/class_finder'
require 'class_herd/interface'
require 'class_herd/interface_discovery_wrapper'
require 'monkeypatch/array'

module ClassHerd
class InterfaceTester
	include ClassHerd::ClassConductor3
	include Test::Unit
	
	attr_accessor :test, :symbols, :int_methods,:default_class, :result,:data, :wrappers

	def initialize (test)
		@test = test
		lazy
	end
	
#this works because klass = on(class)
#creates a duplicate of class, so if we look for every instance of  klass
#we know it's pretty much gaureenteed to be the instances created by the tests
#(unless another thread has found the dup and inited it... ~ which is very unlikely)
#if we kept the test results, we could be sure that they havn't been garbage collected.

#impersonate a class and hook .new to return an instance?
	def lazy
		if @done then return; end
		@done = true
		cr = ClassReferences4.new
		cr.parse(@test)
		@symbols = cr.reffs	
		@default_class = Hash.new
		@int_methods = Hash.new
		to_run = _on(@test) #rewired test class
		@wrappers = Hash.new
		finder = ClassFinder.new
		@idw = InterfaceDiscoveryWrapper.new	
		@symbols.each {|sym|
		begin	
		@default_class[sym] = finder.from_symbol(test,sym.to_s)
		rescue
		puts "#{ClassFinder} could not find class for '#{sym}'" 
		puts "ignoring #{sym}"
		@symbols.delete sym
		puts "remaining: #{@symbols.inspect}"
                
		end
	}
	puts "symbols: #{@symbols.inspect}"
	@symbols.each {|sym|
        		#target_klass = @subjects.find {|sub| sub.name.to_sym == target_sym}
	
			 puts "targets <sym=#{sym.inspect},class=#{default_class[sym]}>"
	
			#wrap each reference which you have a copy of
			#wrappers[sym] = _on(VCR2)._replace(:Object, default_class[sym])
			puts "############"
			puts "wrappers[#{sym}]=#{default_class[sym]}"
			wrappers[sym] = @idw.wrap(default_class[sym])
			puts "############"
			#puts 
			to_run._replace(sym, wrappers[sym])

			if(default_class[sym].nil?) then
				raise "default_class[sym] is nil. wanted: #{sym.inspect}"
			end
			}
		#argh, now how do i get at the VCR2?
		interface = []
		@data = DataForTest.new(to_run)
		@result = data.result
		
		@symbols.each {|sym|
			puts "#{sym}=>#{@idw.interface(default_class[sym])}.inspect}"
			int_methods[sym] = []
			#ObjectSpace.each_object(wrappers[sym])
				if @idw.interface(default_class[sym]) then
				int_methods[sym] = int_methods[sym] +  @idw.interface(wrappers[sym]).collect{|it| 
					it.to_s}
				end
				#}
				int_methods[sym].uniq!
		 puts "INTERFACE: #{sym}=>#{int_methods[sym].inspect}"
				}
			end

	def has_interface? (sym, klass)
		#puts "CLASS #{klass}.has_interface? #{sym}"
		#puts "methods: #{@idw.interface(@wrappers[sym]).inspect}"
		
		unless @wrappers[sym] then
			raise "TestInterface doesn't know #{sym}. can't say if #{klass} has it's interface"
		end
		@idw.is_compatible?(klass,@wrappers[sym])
#		puts klass.methods.sub_set?(int_methods[sym])
#		puts ">>MISSING METHODS>>#{(int_methods[sym] - klass.methods).inspect }"
#		klass.methods.sub_set?(int_methods[sym])
		#!(int_methods[sym].find {|f| !(klass.methods.include? f)})
	end
	def wrappable? 
		result.passed?
	end
	def interface_for(sym)
			Interface.new(@test,s,@int_methods[s])
	end
	def interfaces
		@symbols.collect{|s|
			interface_for(s)
		}
	end

end;end
	
