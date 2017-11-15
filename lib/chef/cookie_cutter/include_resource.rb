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
require 'chef/resource/lwrp_base'

class Chef
  module CookieCutter
    ##
    # Allows custom resources to mixin other resources.
    #
    # @example File my_cookbook/resources/mixins/common.rb
    #   attribute :foo, kind_of: String, default: 'foo'
    #
    # @example File my_other_cookbook/resources/test.rb
    #   include_resource 'mixin/common', cookbook: 'my_cookbook'
    #
    #   attribute :bar, kind_of: String, default: 'bar'
    #
    # @example File my_other_cookbook/recipes/test.rb
    #   my_cookbook_test 'test' do
    #     foo 'Hello'
    #     bar 'World'
    #   end
    #
    module IncludeResource
      require 'chef/cookie_cutter/include_resource/resource_dsl'
      require 'chef/cookie_cutter/include_resource/resource'

      Chef::Resource::LWRPBase.send :extend, ResourceDSL
      Chef::Resource::LWRPBase.send :prepend, CustomResource
    end
  end
end
