# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/clean'
require 'yard'

CLEAN.include 'pkg'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new(:doc)

task test: %i[rubocop spec]
task default: %i[clean test build]
