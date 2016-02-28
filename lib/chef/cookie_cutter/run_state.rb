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

class Chef
  module CookieCutter
    ##
    # Provides methods to easily store values in the Chef run state, so they can
    # be used across recipes.
    #
    # @example File my_cookbook/recipes/test.rb
    #   store_state(:my_cookbook, :test, :foo, 'bar')
    #
    #   file 'testfile' do
    #     content fetch_state(:my_cookbook, :test, :foo)
    #   end
    #
    module RunState
      require 'chef/cookie_cutter/run_state/recipe_dsl'

      ::Chef::Recipe.send :include, RecipeDSL
      ::Chef::Resource.send :include, RecipeDSL
    end
  end
end
