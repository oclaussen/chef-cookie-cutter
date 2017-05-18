# encoding: UTF-8
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'chef/cookie_cutter/version'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/clean'
require 'yard'

CLEAN.include 'pkg'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new(:doc)

task test: [:rubocop, :spec]
task default: [:clean, :test, :build]
