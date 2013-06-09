# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'page_record/version'

Gem::Specification.new do |spec|
  spec.name          = "page_record"
  spec.version       = PageRecord::VERSION
  spec.authors       = ["Bert Hajee"]
  spec.email         = ["hajee@moretIA.com"]
  spec.description   = %q{ActiveRecord like reading from specialy formatted HTML-page}
  spec.summary       = %q{Using some specialy formatted 'data-...' tags you can read records from HTML pages like an ActiveRecord page}
  spec.homepage      = "https://github.com/appdrones/page_record"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  # spec.add_development_dependency "debugger"

  spec.add_dependency "capybara" , '~>2.1.0'
  spec.add_dependency "activesupport"
end
