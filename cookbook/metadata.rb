# encoding: UTF-8
# frozen_string_literal: true

name 'cookie-cutter'
description 'A small collection of Chef hacks and workarounds.'
version '1.1.0'
chef_version '~> 12.19'

maintainer 'Ole Claussen'
maintainer_email 'claussen.ole@gmail.com'
source_url 'https://github.com/oclaussen/chef-cookie-cutter'
issues_url 'https://github.com/oclaussen/chef-cookie-cutter/issues'
license 'Apache-2.0'

supports 'centos'
supports 'debian'

gem 'chef-cookie_cutter', git: 'https://github.com/oclaussen/chef-cookie-cutter.git'
