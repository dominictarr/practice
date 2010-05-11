
#symbolParseCommand

require 'class_reference_parser'
require 'symbol_parser'
require 'ruby_parser'

ARGV.each{|it|
		puts "PARSE: #{it} =>"
		c =ClassHerd::ClassReferenceParser.new(SymbolParser.new.parse(RubyParser.new.parse(File.open(it).read)))
		
		puts c.inspect
}