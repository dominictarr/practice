class Recipe < Sequel::Model(:recipes)

  describe :title, String
  describe :instructions, String

=begin
  def self.describe_title
    StringDescription.new(SymbolAccessor.new(:title, :title=))
  end

  def self.describe_instructions
    StringDescription.new
  end

  def self.describe_self
  end
=end
end
