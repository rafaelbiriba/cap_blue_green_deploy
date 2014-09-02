# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cap_blue_green_deploy/version'

Gem::Specification.new do |spec|
  spec.name          = "Cap Blue Green Deploy"
  spec.version       = CapBlueGreenDeploy::VERSION
  spec.authors       = ["Rafael Biriba"]
  spec.email         = ["biribarj@gmail.com"]
  spec.description   = "Blue-Green deployment solution for Capistrano, using symbolic links between releases."
  spec.summary       = "Blue-Green deployment solution for Capistrano"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
