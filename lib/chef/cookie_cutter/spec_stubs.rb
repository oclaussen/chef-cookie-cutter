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
require 'chef/resource'

class Chef
  module CookieCutter
    ##
    # Extends `not_if` and `only_if` clauses on resources, so they can
    # automatically stub shell commands for ChefSpec.
    #
    # @example File my_cookbook/recipes/test.rb
    #   file '/some/file' do
    #     action :create
    #     content 'Hello World!'
    #     only_if "cat /some/file | grep -q Hello", stub_with: 0
    #   end
    #
    module SpecStubs
      require 'chef/cookie_cutter/spec_stubs/resource_dsl'

      ::Chef::Resource.send :prepend, SpecStubs::ResourceDSL
    end
  end
end
