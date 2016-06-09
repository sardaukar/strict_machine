# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "strict_machine"

Gem::Specification.new do |spec|
  spec.name          = "strict_machine"
  spec.version       = StrictMachine::VERSION
  spec.authors       = ["Bruno Antunes"]
  spec.email         = ["sardaukar.siet@gmail.com"]

  spec.summary       = "State machine functionality for Ruby classes"
  spec.homepage      = "https://not-yet.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 11.1.2"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"

  spec.test_files = Dir["spec/**/*"]
end
