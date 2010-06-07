require 'test/unit'
require 'test/unit/testresult'
require 'class_herd/message'
require 'monkeypatch/class2'

module ClassHerd
#same interface as DataForTest but has extra options and lazy initialization
class DataForTest2
	include Test::Unit
	attr_accessor :test,:replacement,:result, :message
	def initialize (test)
		@message = []
		@test = test
#		@replacement = test.replacements
#		@result = run_unit_tests(test)
		@inited = false
	end

	def logging_on
		@logging = true
		self
	end

	def log (message)
		if @logging then
			puts message
		end
		@message << message
	end
	
	def run

		if @inited then @result; end
		@inited = true
		puts "RUNNING : DataForTest2"

		test_klass = @test
		tests = test_klass.public_instance_methods.find_all{|it| it.to_s =~ /test_.*/}

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
				log FaultMessage.new(value,tr)
			}
			c_test.run(tr) {|status, name|
				if (status == TestCase::FINISHED) then
					log TestEndMessage.new(name,tr)
				end
				}
		}
		log SummaryMessage.new(tr)
		@result = tr
	end
	def print_message
		run
		puts @message.join("\n")	
	end
	def message
		run
		return @message.join("\n")
	end
	def test
		run
		@test
	end
	def result
		run
		@result
	end
end;end
