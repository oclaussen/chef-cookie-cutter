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
require 'chef/resource/lwrp_base'
require 'chef/provider'
require 'chef/provider/lwrp_base'

class Chef
  module CookieCutter
    def self.chef_version(constraint)
      gem_version = ::Gem::Version.new(::Chef::VERSION)
      ::Gem::Requirement.new(constraint).satisfied_by?(gem_version)
    end

    if chef_version('~> 12.5.0.alpha')
      require_relative 'cookie_cutter/fancy_property'
    end

    require_relative 'cookie_cutter/lwrp_build_params'
    require_relative 'cookie_cutter/lwrp_include'
    require_relative 'cookie_cutter/namespace'
    require_relative 'cookie_cutter/run_state'
    require_relative 'cookie_cutter/shared_blocks'
  end
end

CC = Chef::CookieCutter

# Register Monkey Patches
Chef::Node.send :prepend, CC::MonkeyPatches::Node
Chef::Resource::LWRPBase.send :prepend, CC::MonkeyPatches::LWRPResource
Chef::Provider::LWRPBase.send :prepend, CC::MonkeyPatches::LWRPProvider

# Register DSL
Chef::Recipe.send :include, CC::DSL
Chef::Resource.send :include, CC::DSL
Chef::Provider.send :include, CC::DSL
Chef::Node.send :include, CC::AttributeDSL
Chef::Resource::LWRPBase.send :extend, CC::ResourceDSL
Chef::Provider::LWRPBase.send :extend, CC::ProviderDSL
