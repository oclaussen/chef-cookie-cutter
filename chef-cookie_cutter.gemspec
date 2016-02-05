# encoding: UTF-8

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'chef/cookie_cutter/version'

Gem::Specification.new do |spec|
  spec.name         = 'chef-cookie_cutter'
  spec.version      = ::Chef::CookieCutter::VERSION
  spec.author       = 'Ole Claussen'
  spec.email        = 'claussen.ole@gmail.com'
  spec.license      = 'Apache 2.0'
  spec.summary      = 'A small collection of Chef hacks and workarounds.'
  spec.description  = 'A small collection of Chef hacks and workarounds.'
  spec.homepage     = 'https://github.com/oclaussen/chef-cookie-cutter'

  spec.required_ruby_version = '>= 2.0'

  spec.files         = Dir['lib/**/*.{rb,erb}']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rubocop', '~> 0.34'
  spec.add_development_dependency 'rspec', '~> 3.3'
end
