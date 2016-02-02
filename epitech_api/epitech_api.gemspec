# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'epitech_api/version'

Gem::Specification.new do |spec|
  spec.name          = "epitech_api"
  spec.version       = EpitechApi::VERSION
  spec.authors       = ["Etienne Chabert"]
  spec.email         = ["etienne.chabert@gmail.com"]
  spec.summary       = %q{Help to use the Epitech API for basic action}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
