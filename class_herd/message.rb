

module ClassHerd
class TestDataMessage
	attr_accessor :value, :test
	def initialize (v,t = nil)
		@value = v
		@result = t
	end
	
	def to_s; @value.to_s end
	def inspect; @value.inspect end
end

class FaultMessage < TestDataMessage; end
class TestEndMessage < TestDataMessage
	def short 
		if @result.passed? then "."
		elsif @result.error_count > 0 then "E"
		elsif @result.failure_count  > 0 then "F"
		else "0"; end
	end
	
	def to_s 
		"\t" + @value.to_s + " #{short}"
		#+ "\n #{short} \t" + @result.to_s
		end
	
	end
class SummaryMessage < TestDataMessage; end
	#~ def to_s; @value.to_s end
	#~ def inspect; @value.inspect end
#~ end
end
