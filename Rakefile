# encoding: UTF-8
# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/clean'
require 'yard'

CLEAN.include 'pkg'

RuboCop::RakeTask.new(:rubocop)
FoodCritic::Rake::LintTask.new(:foodcritic) { |t| t.options = { tags: ['~FC011', '~FC071'] } }
RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new(:doc)

task test: %i[foodcritic rubocop spec]
task default: %i[clean test build]
