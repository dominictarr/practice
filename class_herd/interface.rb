#require 'monkeypatch/autorunner'
module ClassHerd
class Interface
attr_accessor :test,:symbol, :int_methods
	def initialize(test,symb,methods)
		@test = test
		@symbol = symb
		@int_methods = methods
	end
	def supports? (klass)
	      !(@int_methods.find {|f| !(klass.instance_methods.include? f)})
      end
end;end
