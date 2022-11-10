# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'azure_application_insights/version'

Gem::Specification.new do |spec|
  spec.name          = 'azure_azure_application_insights'
  spec.version       = AzureApplicationInsights::VERSION
  spec.authors       = ['Daniel Blasina']
  spec.email         = ['blzk100@gmail.com']
  spec.summary       = %q{Forked Application Insights SDK for Ruby}
  spec.description   = %q{This project extends the Application Insights API surface to support Ruby.}
  spec.homepage      = 'https://github.com/blasko03/AzureApplicationInsights-Ruby/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard', '~> 0.9.11'
  spec.add_development_dependency 'redcarpet', '~> 3.2.2'
  spec.add_development_dependency 'rack', '>= 1.0.0'
  spec.add_development_dependency 'test-unit', '~> 3.0.8'
  spec.add_development_dependency 'mocha', '~> 1.5.0'

end
