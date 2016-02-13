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
require 'chef/provider'
require 'chef/node'

class Chef
  module CookieCutter
    module Namespace
      require 'chef/cookie_cutter/namespace/dsl'
      require 'chef/cookie_cutter/namespace/monkey_patches'
      require 'chef/cookie_cutter/namespace/namespace'

      ::Chef::Recipe.send :include, DSL
      ::Chef::Resource.send :include, DSL
      ::Chef::Provider.send :include, DSL
      ::Chef::Node.send :prepend, MonkeyPatches::Node
    end
  end
end
