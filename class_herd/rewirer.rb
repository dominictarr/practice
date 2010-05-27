require 'class_herd/class_conductor3'
require 'class_herd/class_references4'
require 'monkeypatch/class2'

module ClassHerd
class Rewirer
	include ClassHerd::ClassConductor3
def for(klass)
	@klass = _on(klass)
	self
end
def reffs
	cr = ClassReferences4.new
	cr.parse(@klass,true)
	cr.reffs
end
def replace(sym, with_klass)
	@klass._replace(sym,with_klass)
	self
end
def klass
		@klass
end
def create (*args,&block)
	klass.new(*args,&block)
end
end;end