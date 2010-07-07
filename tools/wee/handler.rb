module HandlerMixin
  def handles_class
	raise "includers of HandlerMixin must subclass handles_class"
  end
  def handles_class? (klass)
	klass <= handles_class
  end
  def handles? (array)
	array.is_a? handles_class
  end
  def handle (handles)
	@handling = handles
  end
end
module TestsHandlerMixin
  attr_accessor :component
  def wants_handler_for_class
	raise "includers of TestsHandlerMixin must subclass handles_class"
  end
end

