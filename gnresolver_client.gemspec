# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gnresolver_client/version"

Gem::Specification.new do |s|
  s.name          = "gnresolver_client"
  s.version       = GnresolverClient::VERSION
  s.authors       = ["Dmitry Mozzherin"]
  s.email         = ["dmozzherin@gmail.com"]

  s.summary       = "A client for gnresolver API"
  s.homepage      = "https://github.com/dimus/gnparser_client"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0").
                    reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.12"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec_junit_formatter", "~> 0.2"
  s.add_development_dependency "rubocop", "~> 0"
  s.add_development_dependency "byebug", "~> 9.0"
  s.add_development_dependency "coveralls", "~> 0.8"

  s.add_dependency "rest-client", "~> 2.0"

  s.required_ruby_version = ">= 2.0.0"
end
