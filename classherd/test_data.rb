require 'test/unit'
require 'test/unit/testresult'

module  ClassHerd
class TestData
		attr_accessor :test,:replacement,:result
		#def initialize (test,rep,resu)
		def initialize (test)
			
			@test = test.duped || test
			@replacement = test.replacements
			@result = run_unit_tests(@test)
		end

	def run_unit_tests(test_klass)
		tests = test_klass.public_instance_methods.find_all{|it| it.to_s =~ /test_.*/}
		tr = TestResult.new();
		tests.each {|method|

			tr.add_listener(TestResult::FAULT) {|value| puts value.to_s}
			test_klass.new(method).run(tr) {|status, name| 
			#~ if (status == TestCase::FINISHED)
				#~ puts "\t" + name + ":" + tr.to_s
			#~ end
			}
		}
		if tr.passed? then result = "Passed!"
			elsif tr.error_count > 0 then result = "ERROR!"
			else result = "FAILOUR." end
		puts "(#{test_klass})\n\t=>#{result}"
		return tr
	end
	end
end
