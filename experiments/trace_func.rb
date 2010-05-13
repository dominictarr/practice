

class Test
	def initialize
	end
	def test
           a = 1
           b = 2
	   puts "hello"
         end
         end
     
         set_trace_func proc { |event, file, line, id, binding, classname|
#            printf "%8s %s:%-2d%-5d%10s %8s %-10s\n", event, file, line, id, classname, binding
            printf "%8s %s:%-2d %10s %8s %8s\n", event, file, line, id, classname, binding
          }
         t = Test.new
         t.test
	puts t.object_id