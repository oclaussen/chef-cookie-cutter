# encoding: UTF-8
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'chef/cookie_cutter/version'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/clean'

CLEAN.include 'pkg'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)

desc 'Install gem into cookbook'
task install: [:build] do
  file = File.join('pkg', "chef-cookie_cutter-#{::Chef::CookieCutter::VERSION}.gem")
  sh "gem install --install-dir files/default/vendor --no-document #{file}"
end

task test: [:rubocop, :spec]
task default: [:clean, :test, :build, :install]
