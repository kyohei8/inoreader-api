# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inoreader/api/version'

Gem::Specification.new do |spec|
  spec.name          = "inoreader-api"
  spec.version       = Inoreader::Api::VERSION
  spec.authors       = ["kyohei8"]
  spec.email         = ["tsukuda.kyouhei@gmail.com"]
  spec.description   = %q{InoReader Ruby Client}
  spec.summary       = %q{InoReader Ruby Client}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec"

end
