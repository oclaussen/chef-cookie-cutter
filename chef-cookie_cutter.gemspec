# encoding: UTF-8

Gem::Specification.new do |spec|
  spec.name         = 'chef-cookie_cutter'
  spec.version      = '0.0.2'
  spec.author       = 'Ole Claussen'
  spec.email        = 'claussen.ole@gmail.com'
  spec.license      = 'Apache 2.0'
  spec.summary      = 'A small collection of Chef hacks and workarounds.'
  spec.description  = 'A small collection of Chef hacks and workarounds.'
  spec.homepage     = 'https://github.com/oclaussen/chef-cookie-cutter'

  spec.required_ruby_version = '>= 2.0'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'chef', '> 0'

  spec.add_development_dependency 'bundler', '~> 0'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 0'
end
