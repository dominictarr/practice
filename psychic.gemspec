
require 'rubygems'

SPEC = Gem::Specification.new do |spec|
  spec.name = 'psychic'
  spec.version = '0.1.1'
  spec.summary = 'inject listener block into any methods on any object'
  spec.description = <<-EOF
      can inject a block into any method on any object, which will be called back when that method is called.
      for example, may be used to listen to state changes on Array's, Hash's etc.
  EOF
  spec.require_path = "lib"
  spec.files = Dir['lib/*.rb'] + Dir['test/*.rb']
end
