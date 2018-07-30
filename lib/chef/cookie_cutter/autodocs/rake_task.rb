# frozen_string_literal: true

require 'chef/cookie_cutter/autodocs/doc_runner'
require 'erubis'
require 'rake'
require 'rake/tasklib'

class Chef
  module CookieCutter
    module Autodocs
      ##
      # A rake task that creates a `README.md` file based on the metadata set by
      # the autodocs module.
      #
      # @example Rakefile
      #   require 'chef/cookie_cutter/autodocs/rake_task'
      #   Chef::CookieCutter::Autodocs::RakeTask.new
      #
      class RakeTask < ::Rake::TaskLib
        attr_accessor :name, :cookbook_path, :output_file, :template_file

        def initialize(name = :autodoc)
          @name = name
          @cookbook_path = '.'
          @output_file = 'README.md'
          @template_file = Pathname.new("#{File.dirname(__FILE__)}/README.md.erb").realpath

          desc 'Generate cookbook documentation' unless ::Rake.application.last_description
          task(name) do
            template = File.read(@template_file)
            runner = Autodocs::DocRunner.new(@cookbook_path)
            result = Erubis::Eruby.new(template).result(runner.get_binding)
            File.open(@output_file, 'wb') do |file|
              file.write result
            end
          end
        end
      end
    end
  end
end
