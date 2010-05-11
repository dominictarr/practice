#~ module ClassHerd
#~ class TestRewire
	
require 'classherd/class_conductor3'
require 'classherd/class_references4'
require 'test/unit'
require 'test/unit/testresult'

require 'classherd/test_interface'
require 'monkeypatch/array'

include Test::Unit

include ClassHerd::ClassConductor3
module ClassHerd
class TestRewire2
	
	attr_accessor :test_data, :subjects

	def with_interface (test,symbol,classes)
		#return array of classes which have interface
		classes.select {|klass| test.has_interface?(symbol,klass)}
	end
	def sub_map (test_inter,classes)
		map = Hash.new
		test_inter.symbols.each { |sym|
			wi = with_interface(test_inter,sym,classes)
			unless wi.empty? then map[sym] = wi 
			else puts "no subs for #{sym}" end
		}
		map
	end
	def run_test(test_klass)
	interface = TestInterface.new(test_klass)
	#collect classes which have the right interface

	#a test may depend on more than 1 interface.
	#thiere fore there may be more than one substitution
	#number of possible test versions:
	#for each interface
	#collect the classes which have that interface
	#get all combinations
	#make a test.dup for each combination.

	#this needs to be handled somewhere else, so i can extend it.

	sm = sub_map(interface,@subjects)

	#explode hash map
	#cartesian product.
	#monkeypatch a cartesian product method to array

	sm.keys
	#remember to call cartesian with * otherwise it will mean
	#something wuite different.

	#~ puts "all interfaces:"
	#~ puts interface.methods.inspect
	#~ puts "all subs:"
	#~ puts sm.inspect
	#~ puts "all tests:"
	#~ puts sm.keys.inspect
	#~ puts sm.values.inspect

	subs = sm.values
##	if subs.length > 1 then
##		subs = subs.first.cartesian(*subs.tail)
		subs  = Array.cartesian(*subs)
##	else
##		subs = subs.first
##	end
#	puts subs.inspect

#	puts "run all tests..."

	tests = []
	syms = sm.keys
	#~ if syms.length > 0 then
		subs.each{|sub|
	#	puts "map for. #{sub} puts #{syms.length}"
			i = 0
			this_test = _on(test_klass)
			while(i < syms.length) do 
	#			puts "SUB: #{syms[i]}=>#{sub[i]}"
				#substitute into a test.
				if sub[i] then
					this_test._replace(syms[i],sub[i])
				end
				i = i + 1
			end
			tests << this_test
	#		puts this_test.inspect
		}
	#~ else
		#~ symb = syms.first
	#~ subs.each{|sub|
		#~ tests << _on(test_klass)._replace(symb,sub)
	#~ }
	
	#puts "TESTS for #{test_klass}: #{tests.inspect}"
	
	tests.each {|sub| 
		puts "TESTING: " + sub.to_s
		@test_data << TestData.new(sub)
		}
		puts "TESTDATA: " + @test_data.inspect
	#end
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

