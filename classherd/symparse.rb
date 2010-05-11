
#symbolParseCommand

require 'class_references'
require 'symbol_parser'
require 'ruby_parser'

ARGV.each{|it|
		#puts it + ":"
		puts SymbolParser.new.parse(RubyParser.new.parse(File.open(it).read)).inspect

		
}