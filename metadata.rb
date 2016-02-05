# encoding: UTF-8

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'chef/cookie_cutter/version'

name 'cookie-cutter'
description 'A small collection of Chef hacks and workarounds.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version ::Chef::CookieCutter::VERSION

maintainer 'Ole Claussen'
maintainer_email 'claussen.ole@gmail.com'
source_url 'https://github.com/oclaussen/chef-dotfiles'
issues_url 'https://github.com/oclaussen/chef-dotfiles/issues'
license 'Apache 2.0'
