# encoding: UTF-8
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
require 'chef/resource'

class Chef
  module CookieCutter
    ##
    # Custom resources will automatically generate matchers for ChefSpec using
    # their `resource_name` and all actions. Custom `provide` declarations are
    # not considered for matchers.
    #
    # @example File my_cookbook/resources/test.rb
    #   resource_name :test
    #
    #   allowed_actions [:create, :delete]
    #
    # @example File my_cookbook
    #   expect(chef_run).to create_test('foo')
    #   expect(chef_run).to delete_test('bar')
    #
    module SpecMatchers
      require 'chef/cookie_cutter/spec_matchers/monkey_patches'

      ::Chef::Resource::LWRPBase.send :prepend, MonkeyPatches::CustomResource
    end
  end
end
