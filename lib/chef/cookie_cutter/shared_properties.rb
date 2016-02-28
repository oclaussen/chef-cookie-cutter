# encoding: UTF-8
# frozen_string_literal: true
#
# Copyright 2016, Ole Claussen <claussen.ole@gmail.com>
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
require 'chef/recipe'
require 'chef/resource'
require 'chef/cookie_cutter/run_state'

class Chef
  module CookieCutter
    ##
    # Adds a new type of files with their own DSL to Chef cookbooks, named
    # "shared properties". These shared properties allow for the definition of
    # common properties, that should be shared across many resources, or across
    # cookbooks.
    #
    # Currently, these files are housed in the cookbook under `:files` segment,
    # more precisely under `files/default/shared_properties`.
    #
    # @example File my_cookbook/files/default/shared_properties/permissions.rb
    #   share_as :common_file_permissions
    #
    #   always do
    #     owner 'testuser'
    #     group 'testgroup'
    #   end
    #
    #   in_resource :file do
    #     mode '0644'
    #   end
    #
    #   in_resource :directory do
    #     mode '0755'
    #   end
    #
    # @example File my_cookbook/recipes/test.rb
    #   file 'testfile' do
    #     include_properties :common_file_permissions
    #   end
    #
    #   directory 'testdir' do
    #     include_properties :common_file_permissions
    #   end
    #
    module SharedProperties
      require 'chef/cookie_cutter/shared_properties/resource_dsl'
      require 'chef/cookie_cutter/shared_properties/run_context'
      require 'chef/cookie_cutter/shared_properties/cookbook_compiler'

      ::Chef::Resource.send :include, ResourceDSL
      ::Chef::RunContext.send :include, RunContext
      ::Chef::RunContext::CookbookCompiler.send :prepend, CookbookCompiler
    end
  end
end
