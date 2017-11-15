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
require 'chef/property'

class Chef
  module CookieCutter
    ##
    # Adds new validation parameter `:collect` to properties. If set to `true`,
    # the property can be called multiple times on a resource, and all values
    # will be collected in an array.
    #
    # @example File my_cookbook/resources/test.rb
    #   property :foo, collect: true
    #
    # @example File my_cookbook/recipes/test.rb
    #   my_cookbook_test 'test' do
    #     foo 'Hello'
    #     foo 'World'
    #   end
    #
    module CollectProperty
      require 'chef/cookie_cutter/collect_property/property_dsl'
      ::Chef::Property.send :prepend, PropertyDSL
    end
  end
end
