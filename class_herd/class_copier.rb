require 'monkeypatch/class2'

module ClassHerd
class ClassCopier

def initialize
	@@counter = 1
end
def copy(klass)		
	k =  klass.dup
	
	 n = klass.name.split("::").last
	 self.class.const_set(:"#{n}_cc#{@@counter}",k)
	k.send(:instance_variable_set, :@duped, klass.instance_variable_get(:@duped) || klass)
	@@counter += 1
	k
end
end;end
