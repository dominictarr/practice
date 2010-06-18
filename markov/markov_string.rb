

class MarkovString


def initialize (corpus, terminator = "/n")
	@corpus = corpus #the text which random phrases will be generated from.
	@terminator = terminator
end

def regex (seq)
Regexp.new("#{seq}(.)")
end

def next_letter (context)
	context = Regexp.escape(context)
	list = @corpus.scan(regex(context)).flatten
	list[rand(list.length)]
end

def random(length)
context = @terminator
word = ""
while true do
	l = next_letter(context)
	if l == @terminator then
		return word
	end
	word << l
	if word.length <= length then
		context = @terminator + word
	else
		context = word[(-1 * length)..-1]
	end
end

end

end


if $0 == __FILE__ then
require 'markov/names.rb'

context_len = ARGV.length != 0 ? ARGV[0].to_i : 1
names = ""
ObjectSpace.each_object(Module){|n| names = names + " " + n.public_instance_methods.join(" ")
			names << n.name + " "
			}
puts names
#names = english_names
m = MarkovString.new(names," ")
100.times {puts m.random(context_len)}
end
