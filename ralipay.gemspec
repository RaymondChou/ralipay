# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ralipay/version'

Gem::Specification.new do |spec|
  spec.name          = "ralipay"
  spec.version       = Ralipay::VERSION
  spec.authors       = ["RaymondChou"]
  spec.email         = ["freezestart@gmail.com"]
  spec.description   = "A Gem for alipay,contains web payment and mobile payment"
  spec.summary       = "A Gem for alipay"
  spec.homepage      = "http://ledbk.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
