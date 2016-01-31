require 'chef/client'
require 'chef/mash'
require 'chef/recipe'
require 'erubis'
require 'fauxhai'
require 'rake'
require 'rake/tasklib'

class Chef
  module CookieCutter
    module Autodocs
      class RakeTask < ::Rake::TaskLib
        attr_accessor :name, :cookbook_path, :output_file, :template_file

        def initialize(name = :autodoc)
          @name = name
          @cookbook_path = '.'
          @output_file = 'README.md'
          @template_file = Pathname.new("#{File.dirname(__FILE__)}/README.md.erb").realpath

          desc 'Generate cookbook documentation' unless ::Rake.application.last_comment
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

      class DocRunner
        def initialize(cookbook_path)
          @cookbook_path = File.expand_path(cookbook_path)

          Chef::Config.reset!
          Chef::Config[:cache_type] = 'Memory'
          Chef::Config[:node_name] = nil
          Chef::Config[:solo] = true
          Chef::Config[:cookbook_path] = File.dirname(@cookbook_path)
        end

        def recipes
          return @recipes if @recipes
          @recipes = cookbook.recipe_filenames.map do |file|
            recipe = Chef::Recipe.new(cookbook.name, File.basename(file, '.rb'), run_context)
            recipe.from_file(file)
            recipe
          end
          @recipes
        end

        def get_binding # rubocop:disable Style/AccessorMethodName
          binding
        end

        private

        def client
          return @client if @client
          @client = ::Chef::Client.new
          @client.ohai.data = ::Chef::Mash.from_hash(::Fauxhai.mock.data)
          @client
        end

        def node
          return @node if @node
          client.load_node
          @node = client.build_node
          @node
        end

        def run_context
          return @run_context if @run_context
          n = node
          client.setup_run_context
          @run_context = n.run_context
          @run_context
        end

        def compiler
          return @compiler if @compiler
          run_list = node.run_list.expand('_default')
          @compiler = ::Chef::RunContext::CookbookCompiler.new(run_context, run_list, run_context.events)
          @compiler.instance_variable_set(:@cookbook_order, [File.basename(@cookbook_path)])
          run_context.instance_variable_set(:@cookbook_compiler, @compiler)
          @compiler.compile
          @compiler
        end

        def cookbook
          return @cookbook if @cookbook
          compiler # To make sure the compiler has compiled
          @cookbook = run_context.cookbook_collection[File.basename(@cookbook_path)]
          @cookbook
        end
      end
    end
  end
end
