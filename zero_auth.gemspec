# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zero_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "zero_auth"
  spec.version       = ZeroAuth::VERSION
  spec.authors       = ["Braden Schaeffer"]
  spec.email         = ["braden.schaeffer@gmail.com"]
  spec.summary       = %q{Zero configuration authentication starter for Rails.}
  spec.description   = %q{Zero configuration authentication starter for Rails.}
  spec.homepage      = "https://github.com/bschaeffer/zero_auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
