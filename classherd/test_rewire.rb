#~ module ClassHerd
#~ class TestRewire
	
require 'class_conductor3'
require 'class_references4'
require 'test/unit'
require 'test/unit/testresult'
require 'v_c_r2'

include Test::Unit

include ClassHerd::ClassConductor3
module ClassHerd
class TestRewire
	
	attr_accessor :test_data
	class TestData
		attr_accessor :test,:replacement,:result
		def initialize (test,rep,resu)
			@test = test
			@replacement = rep
			@result = resu			
		end
	end

	def run_unit_tests(test_klass)
		tests = test_klass.public_instance_methods.find_all{|it| it.to_s =~ /test_.*/}
		tr = TestResult.new();
		tests.each {|method|

			tr.add_listener(TestResult::FAULT) {|value| puts "HEARD:" + value.to_s}
			test_klass.new(method).run(tr) {|status, name| 
			if (status == TestCase::FINISHED)
				puts "\t" + name + ":" + tr.to_s
			end}
		}
		tr
	end

	def test_interface (test_klass)
	cr=ClassReferences4.new
	cr.parse(test_klass)
	reffs =  cr.reffs
	puts "TEST: #{test_klass}"
	puts "SUBJECTS: #{@subjects.inspect}"
	puts "REFERENCES: #{reffs.inspect}"
	
	#lets just do it with one reference for now.
	target_sym = reffs.first #we are only handling class with no module right now.
						#later we will put this all in a loop.
	target_klass = test_klass.class_eval(target_sym.to_s)#snealily pull the class of the reference out...
	
#	target_klass = @subjects.find {|sub| sub.name.to_sym == target_sym}
	
	puts "targets <sym=#{target_sym.inspect},class=#{target_klass}>"
	
	#wrap each reference which you have a copy of
	vcrclass = _on(VCR2)._replace(:Object, target_klass)#FIX
	twrapper = _on(test_klass)._replace(target_sym, vcrclass)#FIX

	if(target_klass.nil?) then
		raise "target_klass is nil. wanted: #{target_sym.inspect}"
	end
	#argh, now how do i get at the VCR2?
	interface = []
	run_unit_tests(twrapper)
	ObjectSpace.each_object(vcrclass){|it| interface  = interface + it.interface}

#this works because klass = on(class)
#creates a duplicate of class, so if we look for every instance of  klass
#we know it's pretty much gaureenteed to be the instances created by the tests
#(unless another thread has found the dup and inited it... ~ which is very unlikely)
#if we kept the test results, we could be sure that they havn't been garbage collected.

#impersonate a class and hook .new to return an instance?
	interface.uniq!
	puts "INTERFACE: #{interface.inspect}"
	return interface, reffs
	end

	def run_test(test_klass)
	interface, reffs = test_interface(test_klass)
	#collect classes which have the right interface
	
	test_subjects = []
	@subjects.select {|sub|
			inc = true
			interface.each {|m|
			if !(sub.method_defined?(m)) then inc = false; end
			}
			if inc then test_subjects << sub else
#				puts "dont test: #{sub}"
				end
	}

	puts "interface tested: #{test_subjects.inspect}"
	#test if 
	puts "run all tests..."

	tests = []
	test_subjects.each{|sub|
	tests << _on(test_klass)._replace(:Primes,sub)#FIX
	}

	tests.each {|sub| 
		puts "TESTING: " + sub.to_s
		@test_data << TestData.new(test_klass, sub.replacements, run_unit_tests(sub))
	}

#~ okay, now how can I automate this? 
#~ for a given test, 
	#~ parse test
	#~ find references
	#~ find interfaces
#~ get [list of classes with interface]
#~ plug them into test
#	end

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

