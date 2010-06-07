#!/usr/bin/ruby 

require 'rubygems'
require 'trollop'
require 'class_herd/composition3'
require 'class_herd/composer2'
require 'class_herd/recomposer'
require 'class_herd/data_for_test'
require 'monkeypatch/array'
require 'yaml'

module ClassHerd
class ComposerCmd
def v (message)
	if @opts[:verbose] then
		puts message
	end
end
def required (rs)
	puts rs.inspect
	rs.each{|r|
		unless @requires.include? r then
			@requires << r
			require r
		end
	}
end
def load (file)

		s = File.open(file).read.split("---")
		required yaml(s[1])
		return yaml(s[2])
end

def yaml (y)
	YAML::load(y)
end

def self_compose
	if @opts[:composition] then
		v "SELF COMPOSING"
		c = Composer2.new(load(@opts[:composition])).classes
		i = @argv_orig.index @opts[:composition]

#		puts @argv_orig.inspect
#		@argv_orig.delete_at(i)
#		@argv_orig.delete_at(i - 1)
		@argv_orig[i-1] = "-S"
#		puts "delete_at #{@opts[:composition].inspect} : #{i.inspect}"
#		puts @argv_orig.inspect
		v "dynamic composer>#{@opts[:composition]} #{@argv_orig.join(" ")}"

		c.new(@argv_orig)
		#exit(0)
		return true
	end
end

def initialize (argv)
	@argv = argv
		puts @argv.inspect
	
	@requires = []
	if @argv.empty? then
		@argv << '--help'
	else
		@argv = @argv[0].split(" ") + argv.tail
	end
	@argv_orig = @argv.dup

	@opts = Trollop::options (@argv) do

	  opt :class,  "specifiy Class to be composed"  ,:type => String
	  opt :command,  "command to (e)xecute on composition"  ,:type => String, :short => :e
	  opt :yaml, "yaml composition to load" ,:type => :string
	  opt :output, "yaml composition to (o)utput" ,:type => :string, :short => :o
	  opt :require, ".rb files to require"  ,:type => :strings, :multi => true
	  opt :exit, "exit immediately following command", :short => :x
	  opt :remap, "re(m)ap one of the mappings. [symbol =\\> {symbol2 =\\>...} ClassName]
 			-m can be used more than once for multiple remaps. remember the \\'s", :type => :strings, :multi => true, :short => :m
	  opt :composition , "yaml defining compo(s)ition of composition command", :short => :s, :type => :string
	  opt :composition2 , "yaml defining compo(s)ition of composition command for output", :short => :S, :type => :string
	  opt :test, "run composition as unit test (currently supports: Test::Unit)"
	  opt :verbose, "print information about composition"
  end
	if self_compose then return; end

		v "options: #{@opts.inspect}"

	if @opts[:require] then
		v "require #{@opts[:require].join(',')}"
		required @opts[:require].flatten
	end
	if @opts[:class] then
		c = Composition3.new.defaults(Object,Array,Exception,Hash,String).read(eval(@opts[:class]))
		comp = c.composition
	elsif @opts[:yaml] then
		comp = load(@opts[:yaml])
	end

	v("composition:\n" + comp.inspect)

	if @opts[:remap] then
		@opts[:remap].each{|r|
			Recomposer.new(comp).recompose_cmd(r.join)
		}
	v( "recomposition:\n" + comp.inspect)
	
	end

	c = Composer2.new(comp).classes

	def inn_s(switch,arg)
		if arg then
			"#{switch} \"#{arg}\""
		else
			""
		end
	end
	def inn(switch,arg)
		if arg then
			"#{switch} #{arg}"
		else
			""
		end
	end

	if @opts[:output] then
		out = File.new(@opts[:output], "w")
	#	o=  "#! bin/composer #{inn("--require",@opts[:require].flatten.join(" "))} #{inn_s("--command",@opts[:command])} #{@opts[:exit] ? "--exit" :""} #{@opts[:test]? "--test":""} --yaml "
	o=  "#! bin/composer #{inn("-s", @opts[:composition2])} #{inn_s("--command",@opts[:command])} #{@opts[:exit] ? "--exit" :""} #{@opts[:test]? "--test":""} --yaml "
		v o
		out.puts o
		v @requires.to_yaml
		v comp.to_yaml
		out.puts @requires.to_yaml
		out.puts comp.to_yaml
	end

	if @opts[:command] then
		v "command: #{@opts[:command]}"
		c.class_eval(@opts[:command])
	end

	if @opts [:test] then
		v "RUNNING TEST:"
		DataForTest.new(c).print_message
		exit(0)
	end

	if @opts[:exit]
		v "done."
		exit(0)
	end
end
end;end
