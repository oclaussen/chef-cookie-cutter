# frozen_string_literal: true

#
# Copyright 2017, Ole Claussen <claussen.ole@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/cookie_cutter/autodocs/markdown_helper'
require 'chef/client'
require 'chef/mash'
require 'chef/recipe'
require 'fauxhai'

class Chef
  module CookieCutter
    module Autodocs
      class DocRunner
        include Chef::CookieCutter::Autodocs::MarkdownHelper
        include Chef::Mixin::ConvertToClassName

        def initialize(cookbook_path)
          @cookbook_path = File.expand_path(cookbook_path)
          Chef::Config.reset!
          Chef::Config[:cache_type] = 'Memory'
          Chef::Config[:client_key] = nil
          Chef::Config[:client_name] = nil
          Chef::Config[:cookbook_path] = File.dirname(@cookbook_path)
          Chef::Config[:no_lazy_load] = true
          Chef::Config[:node_name] = nil
          Chef::Config[:solo] = true
          Chef::Config[:solo_legacy_mode] = true
          Chef::Config[:use_policyfile] = false
        end

        def metadata
          cookbook.metadata
        end

        def recipes
          return @recipes if @recipes
          @recipes = cookbook.recipe_filenames.map do |file|
            next if File.basename(file, '.rb').start_with?('_')
            recipe = Chef::Recipe.new(cookbook.name, File.basename(file, '.rb'), run_context)
            recipe.from_file(file)
            recipe
          end.compact
          @recipes
        end

        def resources
          return @resources if @resources
          @resources = cookbook.resource_filenames.map do |file|
            next if File.basename(file, '.rb').start_with?('_')
            resource_class = Class.new(Chef::Resource::LWRPBase)
            cookbook_name = cookbook.name
            resource_class.define_singleton_method(:resource_cookbook_name) { cookbook_name }
            resource_class.resource_name = filename_to_qualified_string(cookbook.name, file)
            resource_class.run_context = run_context
            raise IOError, "Cannot open or read #{file}!" unless File.exist?(file) && File.readable?(file)
            resource_class.class_eval(IO.read(file), file, 1)
            next if resource_class.internal?
            resource_class
          end.compact
          @resources
        end

        def get_binding # rubocop:disable Style/AccessorMethodName
          binding
        end

        private

        def client
          return @client if @client
          @client = Chef::Client.new
          @client.ohai.data = Mash.from_hash(::Fauxhai.mock.data)
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
          @compiler = Chef::RunContext::CookbookCompiler.new(run_context, run_list, run_context.events)
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
