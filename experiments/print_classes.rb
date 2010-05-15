
#print all modules under the module named in ARGV

#@done = Hash.new

require 'test/unit'
require 'rubygems'
#require 'class_herd/test_test_rewiring'
require 'class_herd/class_references4'
require 'monkeypatch/array'
#module ClassHerd
def self.print_class(klass, indent, ancestors)
#	@done[klass] = true
	puts (klass.is_a?(Class) ? "_" : ">") + indent + klass.name
	if klass == Object then return; end
		cr = ClassHerd::ClassReferences4.new 
	begin
		cr.parse(klass)
	rescue Exception =>e
	puts "NOPARSE : #{klass}-->#{e}"
	end 
		c = cr.reffs
		ancestors.push(klass)

		c.each{|it|
			begin
				i = cr.default_class(it)
			rescue Exception=>e
				puts "couldn't find class for #{it} on #{klass}-->#{e}"
			end
			if i.is_a? Class  and !(ancestors.include? i) then
				print_class(i,indent + ".",ancestors)
			end
		}
		ancestors.pop
end
if(ARGV.empty?) then
	print_class(Module,"",[])
else
if !(ARGV.tail.nil?) then
	ARGV.tail.each{|it| puts "require #{it}"
	require it
	}
	end
	print_class(eval(ARGV[0]),"",[])
end
#end