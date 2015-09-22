# encoding: UTF-8

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

desc 'Run rspec unit tests'
RSpec::Core::RakeTask.new(:spec)

task test: [:rubocop, :spec]
task default: :test
