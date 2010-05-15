require 'class_herd/rb_parser'

module ClassHerd 
class FileExplorer
	attr_accessor :basedir,:rb_files

	def filename(file)
		return ((@path + [file]).join(@seperator))
	end
	def map_classes (classes, rb_file)
		classes.each{|k|
		rbs = @classes_to_rb[k]
		if rbs.nil? then
			@classes_to_rb[k] = [rb_file]
		else
			@classes_to_rb[k] << rb_file
		end
		}
	end
	def explore_dir(dir)
	#	puts ([@path] + ["x"]).join(@seperator)
		dir.each{ |it|
			if it.nil? then
				raise "a file is nil!"
			elsif it =~ /^\.\.?$/ then
			#	puts it
			elsif File.directory? it then
				@path.push it
				explore_dir(Dir.new(it))
				@path.pop
			elsif it =~ /^.*\.rb$/ then
				fn = filename(it)
				@rb_files << fn
				p = RbParser.new(fn)
				begin
					p.parse
					map_classes(p.classes,fn)
					puts "#{fn}->#{p.classes.join(",")}"
				rescue Exception=>e
					puts "cant load #{fn} -> #{e}"
				end
			end
		}
	end
	def rb_for_symb (symbol)
		@classes_to_rb[symbol]  
	end
	def initialize (basedir)
		@seperator = "/" #lib method to get this?
		@path = [basedir]
		@rb_files = []
		@classes_to_rb = Hash.new
		explore_dir(Dir.new(basedir))
	end
	def continue(dir)
		@path = [dir.path]
		explore_dir(dir)
	end
	def self.explore_path
		explore = nil
		$:.each{|it|
		if File.exists? it then
			if explore.nil? then
				explore = FileExplorer.new(it)
			else
				explore.continue(Dir.new(it))
			end
		 end
		}
	end
end;end
