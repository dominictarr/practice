
#print all modules under the module named in ARGV

@done = Hash.new

require 'test/unit'
require 'rubygems'
require 'class_herd/test_test_rewiring'

#how different would this look if it was width first?
#or what if it didn't print it's parents?
def print_mod(mod, indent, ancestors)
	@done[mod] = true
	c = mod.constants.reverse
	puts (mod.is_a?(Class) ? "_" : ">") + indent + mod.name
	ancestors.push(mod)
	c.each{|it|
#		puts it
		i = mod.const_get(it.to_sym)
		if i.is_a? Module  and !(ancestors.include? i) then
			print_mod(i,indent + ".",ancestors)
	#	else
		#	puts "//" + it
		end
	}
	ancestors.pop
end
if(ARGV.empty?) then
	print_mod(Module,"",[])
else
print_mod(Module.const_get(ARGV[0].to_sym),"",[])
end