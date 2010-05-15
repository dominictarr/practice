require 'test/unit'
require 'test/unit/testresult'
require 'class_herd/class_references4'
require 'class_herd/class_conductor3'
require 'class_herd/v_c_r2'
require 'class_herd/test_data'
require 'class_herd/class_finder'

module ClassHerd
class TestInterface
	include ClassHerd::ClassConductor3
	include Test::Unit
	
	attr_accessor :test, :symbols, :methods,:default_class, :result

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
		if @done then return; 
		end
		@done = true
		cr = ClassReferences4.new
		cr.parse(@test)
		@symbols = cr.reffs	
		@default_class = Hash.new
		@methods = Hash.new
		to_run = _on(test) #rewired test class
		wrappers = Hash.new
		finder = ClassFinder.new
		@symbols.each {|sym|
			@default_class[sym] = finder.from_symbol(test,sym.to_s)
		
			#target_klass = @subjects.find {|sub| sub.name.to_sym == target_sym}
	
			#~ puts "targets <sym=#{sym.inspect},class=#{default_class[sym]}>"
	
			#wrap each reference which you have a copy of
			wrappers[sym] = _on(VCR2)._replace(:Object, default_class[sym])
			to_run._replace(sym, wrappers[sym])

			if(default_class[sym].nil?) then
				raise "default_class[sym] is nil. wanted: #{sym.inspect}"
			end
			}
		#argh, now how do i get at the VCR2?
		interface = []
		data = TestData.new(to_run)
		@result = data.result
		
		@symbols.each {|sym|
				methods[sym] = []
			ObjectSpace.each_object(wrappers[sym]){|it|
				methods[sym] = methods[sym] +  it.interface.collect{|it| 
					it.to_s}}
				methods[sym].uniq!
		#~ puts "INTERFACE: #{sym}=>#{methods[sym].inspect}"
				}
			end
	def has_interface? (sym, klass)
		 !(methods[sym].find {|f| !(klass.instance_methods.include? f)})
	end
	def wrappable? 
		result.passed?
	end
end;end
	