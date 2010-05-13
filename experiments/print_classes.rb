
#print all modules under the module named in ARGV

@done = Hash.new

require 'test/unit'
require 'rubygems'
require 'class_herd/test_test_rewiring'
require 'class_herd/class_references4'
module ClassHerd
def self.print_class(klass, indent, ancestors)
#	@done[klass] = true
	puts (klass.is_a?(Class) ? "_" : ">") + indent + klass.name
	if klass == Object then return; end
	begin
		cr = ClassHerd::ClassReferences4.new 
		cr.parse(klass)
		c = cr.reffs
		ancestors.push(klass)

		c.each{|it|
	#		puts ":"it.to_s
			i = klass.class_eval(it.to_s)

			if i.is_a? Class  and !(ancestors.include? i) then
				print_class(i,indent + ".",ancestors)
			end
		}
		ancestors.pop
	rescue Exception =>e
	puts e
	end 
#	end
end
if(ARGV.empty?) then
	print_class(Module,"",[])
else
	print_class(eval(ARGV[0]),"",[])
end
end