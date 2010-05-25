#~ module ClassHerd
#~ class TestRewire

require 'class_herd/class_conductor3'
require 'class_herd/class_references4'
require 'test/unit'
require 'test/unit/testresult'

require 'class_herd/interface_tester'
require 'monkeypatch/array'

include Test::Unit

include ClassHerd::ClassConductor3
module ClassHerd
class RewiringTester
	
	attr_accessor :test_data, :subjects

	def with_interface (test,symbol,classes)
		#return array of classes which have interface
	puts "with_interface:"	
	classes.select {|klass|
	puts "#{symbol}->#{klass}== #{test.has_interface?(symbol,klass)}" 
	test.has_interface?(symbol,klass)
	}
	end
	def sub_map (test_inter,classes)
		map = Hash.new
		test_inter.symbols.each { |sym|
			wi = with_interface(test_inter,sym,classes)
			puts "with_interface: #{sym}=>#{wi.inspect}"
			unless wi.empty? then map[sym] = wi 
			else puts "no subs for #{sym}" end
		}
		map
	end
	def run_test(test_klass)
	interface = InterfaceTester.new(test_klass)

	sm = sub_map(interface,@subjects)
	sm.keys

	subs = sm.values
	subs  = Array.cartesian(*subs)
	tests = []
	syms = sm.keys
		subs.each{|sub|
			i = 0
			this_test = _on(test_klass)
			while(i < syms.length) do 
				if sub[i] then
					this_test._replace(syms[i],sub[i])
				end
				i = i + 1
			end
			tests << this_test
		}	
	tests.each {|sub| 

	@test_data << DataForTest.new(sub)}
	end
	
	def initialize (tests, klasses)
		@subjects = klasses
		@tests = tests
		@test_data = []
	end

	def run_tests
		@tests.each {|t| run_test t}
	end

end;end

