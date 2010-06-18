class MarkovString2

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
end

