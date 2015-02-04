# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jira_report/version'

Gem::Specification.new do |spec|
  spec.name          = 'jira_report'
  spec.version       = JiraReport::VERSION
  spec.authors       = ['Vitalii Elenhaupt']
  spec.email         = ['velenhaupt@gmail.com']
  spec.summary       = %q{Jira activity report generator.}
  spec.description   = %q{Generates a productivity report base on activities in jira.}
  spec.homepage      = 'https://github.com/veelenga/jira_report.git'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'inifile', '~> 3.0'
  spec.add_runtime_dependency 'rest-client', '~> 1.7'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
