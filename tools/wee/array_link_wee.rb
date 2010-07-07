
require 'wee'

class ArrayLinkWee < Wee::Component 
  include HandlerMixin
  def handles_class; Array; end
  def handle (array)
	@array = array
  end

  def name_field(name)
	@name = name
  end
  def callback (&block)
	@callback = block
	self
  end
  def get_name(obj)
	  puts "name for: #{obj}"
#	  puts "name for: #{obj.name}"

	if obj.is_a? String then
	  obj
	elsif @name and obj.methods.include? @name and obj.method(@name).arity == 0 then
	  obj.method(obj)
	elsif obj.methods.include? "name"
	  puts "OBJECT IS NAMED: #{obj.name}"
	  obj.name
	else 
	  s = obj.to_s
	  s.length > 100 ? s[0...100] + '...' : s
	end
  end
  def render (r)
	if @array.nil? then
	   r.label "[]"
	else
  	  @array.each{|a|
		r.anchor.callback {
		puts "chose:" + a.inspect
		@callback.call a}.with(get_name(a))
		r.break
  	  }
	end
  end
end


Wee.runcc(ArrayLinkWee, :server => :Mongrel) if __FILE__ == $0
