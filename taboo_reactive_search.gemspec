# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taboo_reactive_search/version'

Gem::Specification.new do |spec|
  spec.name          = "taboo_reactive_search"
  spec.version       = TabooReactiveSearch::VERSION
  spec.authors       = ["no-glue"]
  spec.email         = ["nikolapav1985@gmail.com"]
  spec.description   = %q{taboo reactive search to solve travelling salesman}
  spec.summary       = %q{taboo reactive search to solve travelling salesman}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
