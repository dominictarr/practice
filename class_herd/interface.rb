require 'class_herd/test_interface'
require 'monkeypatch/autorun'
module ClassHerd
class Interface
attr_accessor :test,:symbol, :int_methods
def initialize(test,symb,methods)
	@test = test
	@symbol = symb
	@int_methods = methods
end
def supports? (klass)
      !(@methods.find {|f| !(klass.instance_methods.include? f)})
end
end;end
