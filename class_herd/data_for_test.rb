require 'test/unit'
require 'test/unit/testresult'
require 'class_herd/message'
require 'monkeypatch/class2'

module ClassHerd
	class DataForTest
		include Test::Unit
		attr_accessor :test,:replacement,:result, :message
		def initialize (test)
			@message = []
			@test = test.duped || test
			@replacement = test.replacements
			@result = run_unit_tests(test)
		end
		def run_unit_tests(test_klass)
			tests = test_klass.public_instance_methods.find_all{|it| it.to_s =~ /test_.*/}
			#all = []
			tr = TestResult.new()
			tests.each {|method|
				#all << tr
				begin
					c_test = test_klass.new(method)
				rescue Exception => e

				if test_klass.instance_method(method) then
					reason = "#{test_klass}.respond_to?(#{method}) == false"
               			else #elsif (method(test_method_name).arity == 0 ||
                			#method(test_method_name).arity == -1))
					reason = "#{test_klass}.method(:#{method}).arity = #{test_klass.instance_method(method).arity} (should be 0 or -1)"
				end
					raise "problem with test #{test_klass}.#{method}\n because: #{reason} \n #{e}"
				end
				tr.add_listener(TestResult::FAULT) {|value|
				@message << FaultMessage.new(value,tr)
				#pass this to another class?
				#then it will be possible to reconfigure this class
				#puts value.to_s
				}
				c_test.run(tr) {|status, name|
				if (status == TestCase::FINISHED) then
					@message << TestEndMessage.new(name,tr)
				end
				#~ puts "\t" + name + ":" + tr.to_s
				#~ end
				}
			}
			@message << SummaryMessage.new(tr)
		tr
	end
	def print_message
		puts @message.join("\n")	
		#.collect{|i| i.inspect}
	end
end;end
