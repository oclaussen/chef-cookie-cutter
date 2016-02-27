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
    # Uses the run state to define blocks of properties that can be used
    # repeatedly across recipes and resources.
    #
    ## Examples:
    #
    # ```ruby
    # share_properties :foo do
    #   content 'foo'
    #   mode '0644'
    # end
    #
    # file 'testfile' do
    #   include_properties :foo
    # end
    # ```
    ##
    module IncludeProperties
      require 'chef/cookie_cutter/include_properties/resource_dsl'
      require 'chef/cookie_cutter/include_properties/run_context'
      require 'chef/cookie_cutter/include_properties/cookbook_compiler'

      ::Chef::Resource.send :include, ResourceDSL
      ::Chef::RunContext.send :include, RunContext
      ::Chef::RunContext::CookbookCompiler.send :prepend, CookbookCompiler
    end
  end
end
