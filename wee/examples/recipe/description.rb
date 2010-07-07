class Accessor
end

class SelectorAccessor < Accessor
  def initialize(symbol, write_symbol=nil)
    @read_symbol = symbol
    @write_symbol = write_symbol || :"#{symbol}="
  end

  def [](object)
    object.send(@read_symbol)
  end

  def []=(object, value)
    object.send(@write_symbol, value)
  end
end

####################################################

class Description
  def initialize
    yield self if block_given?
  end

  def to_string(value)
    value.to_s
  end
end

class ContainerDescription < Description
  def initialize
    super
    @elements = []
  end

  include Enumerable

  def each(&block)
    @elements.each(&block)
  end

  def <<(element)
    @elements << element
  end

  def push(*args)
    @elements.push(*args)
  end
end

class ElementDescription < Description
  attr_accessor :accessor
  attr_accessor :label

  def initialize
    @conditions = []
    super
  end

  def selector_accessor(*args)
    self.accessor = SelectorAccessor.new(*args)
  end

  def required
    @required = true
  end

  def add_condition(cond, label=nil)
    @conditions = cond 
  end
end

class StringDescription < ElementDescription
end

####################################################

class Description
  TYPE_MAP = {
    String => StringDescription
  }
end

class Module
  def describe_self
    coll = ContainerDescription.new
    #
    # we want mixed in modules
    #
    ancestors.each {|m|
      next if m == self or m.is_a?(Class)
      coll.push(*m.describe_self)
    }
    methods.each {|m|
      coll << send(m) if m.to_s.start_with?('describe_') and m.to_s != 'describe_self'
    }
    coll
  end

=begin
  def describe(attribute, type)
    self.class.send(:define_method, "describe_#{attribute}") do
      description = Description::TYPE_MAP[type] || Description
      d = description.new
      d.accessor ||= SymbolAccessor.new(attribute) 
      d
    end
  end
=end
end

class Object
  def describe_self
    self.class.describe_self
  end
end

module Mixin
  attr_accessor :mixin
  def self.describe_mixin
    "blah"
  end
end

class Person
  attr_accessor :name

  def self.describe_name
    #StringDescription.new.selector_accessor(:name).label('Name').required

    StringDescription.new {|s|
      s.selector_accessor(:name)
      s.label = 'Name'
      s.required
      s.add_condition(proc {|value| value.size <= 5}, 'too long')
    }
  end
end

class Recipe
  attr_accessor :a, :b

  #describe :a, String
  #describe :b, String

  #def self.describe_b
  #  "bello"
  #end
end

=begin
recipe = Recipe.new
Recipe.describe_self.each do |r|
  r.accessor[recipe] = rand()
  p r.accessor[recipe]
end

p recipe
=end

#p Person.describe_self

a = Person.new
a.name = "Michael Neumann"

a.describe_self.each {|d|
  print "#{d.label}: "
  puts d.to_string(d.accessor[a])
}
