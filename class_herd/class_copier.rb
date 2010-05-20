require 'monkeypatch/class2'

module ClassHerd
class ClassCopier

def initialize
	@counter = 1
end
def copy(klass)
	k =  klass.dup
	#klass.name.
	 n = klass.name.split("::").last
	 self.class.const_set(:"#{n}_cc#{@counter}",k)
	k.send(:instance_variable_set, :@duped, klass)
	k
end
end;end
