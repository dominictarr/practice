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
		def check_symbols(s)
		s.each{|t|
		unless Symbol === t then
			raise "expected a symbol, but found #{t.inspect}, which is a #{t.class}"
		end
		}
	end
	
	def lazy
		if @done then return; end
		@done = true
		cr = ClassReferences4.new
		cr.parse(@test)
		@symbols = cr.reffs
		check_symbols(@symbols)
		puts 
		@default_class = Hash.new
		@int_methods = Hash.new
		to_run = _on(@test) #rewired test class
		@wrappers = Hash.new
		finder = ClassFinder.new
		@idw = InterfaceDiscoveryWrapper.new	

		puts "-------------------- start INTERFACE TEST -(#{@test.inspect}) ---"
		#puts "Setting up Interface tests for #{@test.inspect}"
		puts "<<<<"
		puts "references: #{@symbols.inspect}"

		@symbols.each {|sym|
		begin	
		@default_class[sym] = finder.from_symbol(test,sym.to_s)
		rescue
		puts "#{ClassFinder} could not find class for '#{sym}'" 
		puts "ignoring #{sym}"
		@symbols.delete sym
		end
		}
		puts "default classes: #{@symbols.collect{|it| default_class[it]}.inspect}"
		@symbols.each {|sym|
        		#target_klass = @subjects.find {|sub| sub.name.to_sym == target_sym}
	
#			 puts "targets <sym=#{sym.inspect},class=#{default_class[sym]}>"
	
			#wrap each reference which you have a copy of
			#wrappers[sym] = _on(VCR2)._replace(:Object, default_class[sym])
			#~ puts "############"
			#~ puts "wrappers[#{sym}]=#{default_class[sym]}"
			wrappers[sym] = @idw.wrap(default_class[sym])
			#~ puts "############"
			#~ #puts
			to_run._replace(sym, wrappers[sym])
			puts "REMAP #{sym.inspect}->#{wrappers[sym].inspect}"
			
			#when interface tester is running in an interface test it seems miss the replacement,
			#and end up using the defaults instead. hence, the IDW doesn't hear anything.
			#what I think is happening, is sym is changing or the reference on the duplicated class is different!
			
			
			if(default_class[sym].nil?) then
				raise "default_class[sym] is nil. wanted: #{sym.inspect}"
			end
			}
		puts "wrappers: #{@symbols.collect{|it| wrappers[it]}.inspect}"
		
		#argh, now how do i get at the VCR2?
		interface = []
		puts "Run Test :#{to_run.inspect}"
		@data = DataForTest.new(to_run)
		@result = data.result

		puts "...#{wrappable? ? "Pass" : "FAIL"}"
		
		@symbols.each {|sym|
#			puts "#{sym}=>#{@idw.interface(default_class[sym])}.inspect}"
			@int_methods[sym] = []
			#ObjectSpace.each_object(wrappers[sym])
				puts default_class[sym].inspect
				if @idw.interface(@wrappers[sym]) then
#					puts "	#{sym.inspect}-->#{@idw.interface(@wrappers[sym])}"
					@int_methods[sym] = @int_methods[sym] +  @idw.interface(default_class[sym]).collect{|it| 
					it.to_s}
				end
				#}
				@int_methods[sym].uniq!
				}
		puts ". . . . . . . "
		puts "Interface Methods:"
				@symbols.each{|sym|
				puts "	#{sym.inspect} (#{default_class[sym].inspect})-> #{@int_methods[sym].inspect}"
				}
	puts ">>>>"
	puts "------------------- finish INTERFACE TEST -(#{@test.inspect}) ---"
	puts @data.message
	
	end

	def has_interface? (sym, klass)
		#puts "CLASS #{klass}.has_interface? #{sym}"
		#puts "methods: #{@idw.interface(@wrappers[sym]).inspect}"
		
		unless @default_class[sym] then
			raise "TestInterface doesn't know #{sym}. can't say if #{klass} has it's interface"
		end
		@idw.is_compatible?(klass,@default_class[sym])
		#puts klass.methods.sub_set?(int_methods[sym])
		#puts ">>MISSING METHODS>>#{(int_methods[sym] - klass.methods).inspect }"
		#klass.methods.sub_set?(int_methods[sym])
		#!(int_methods[sym].find {|f| !(klass.methods.include? f)})
	end
	def wrappable? 
		@result.passed?
	end
	def interface_for(sym)
		#~ puts "-->interface_for(#{sym.inspect})"
		Interface.new(@test,sym,@int_methods[sym])
	end
	def interfaces
		#~ check_symbols(@symbols)
		@symbols.collect{|s|
			interface_for(s)
		}
	end
	

end;end
	
