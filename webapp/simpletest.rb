#! ruby
 require 'rubygems'
 require 'mongrel'

 class SimpleHandler < Mongrel::HttpHandler
    def initialize (message)
	@message = message
    end
    def process(request, response)
      response.start(200) do |head,out|
        head["Content-Type"] = "text/plain"
        out.write("#{@message}\n")

        out.write("#{(request.methods - request.class.superclass.instance_methods).join("\n")}\n")

        out.write("#params\n")
        out.write("#{request.params.inspect}\n")
	
#        out.write("#{request.params.join("\n")}\n")

        out.write("#{request.inspect}\n")

      end
    end
 end

 h = Mongrel::HttpServer.new("0.0.0.0", "3000")
 h.register("/test", SimpleHandler.new("hello!"))
 h.register("/files", Mongrel::DirHandler.new("."))
# h.register("*", SimpleHandler.new("asgrhklasdhgkljslhl!"))

 h.run.join
