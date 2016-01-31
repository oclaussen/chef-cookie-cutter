# encoding: UTF-8
#
# Copyright 2015, Ole Claussen <claussen.ole@gmail.com>
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
require 'chef/cookie_cutter/run_state'

class Chef
  module CookieCutter
    module IncludeProperties
      require 'chef/cookie_cutter/include_properties/dsl'
      require 'chef/cookie_cutter/include_properties/errors'

      ::Chef::Recipe.send :include, DSL
      ::Chef::Resource.send :include, DSL
      ::Chef::Provider.send :include, DSL
    end
  end
end
