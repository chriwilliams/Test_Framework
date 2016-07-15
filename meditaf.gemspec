# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'FirstFramework/version'

Gem::Specification.new do |spec|
  spec.name = 'First_Framework'
  spec.version = FirstFramework::VERSION
  spec.authors = ['Medidata Test Automation Framework Team']
  spec.email = ['chriwilliams_23@yahoo.com']
  spec.description = %q{ Test Automation Framework}
  spec.summary = %q{ Test Automation Framework}
  spec.homepage = %q{}
  spec.licenses = ['MIT', 'LICENSE']

  spec.files = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'require_all', '~> 1.3.2'
  spec.add_dependency 'logging', '~> 1.8.2'
  spec.add_dependency 'faker', '>= 1.3'
  spec.add_dependency 'gmail'
  spec.add_dependency 'multi_xml'
  spec.add_dependency 'selenium-webdriver', '>= 2.46'

end
