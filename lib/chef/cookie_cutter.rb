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
    require_relative 'cookie_cutter/extended_provides'
    require_relative 'cookie_cutter/fake_resource'
    require_relative 'cookie_cutter/fancy_property'
    require_relative 'cookie_cutter/include_resource'
    require_relative 'cookie_cutter/namespace'
    require_relative 'cookie_cutter/run_state'
    require_relative 'cookie_cutter/shared_blocks'
    require_relative 'cookie_cutter/spec_matchers'
  end
end

Chef::CookieCutter::ExtendedProvides.register
Chef::CookieCutter::FancyPropertyModule.register
Chef::CookieCutter::IncludeResource.register
Chef::CookieCutter::Namespace.register
Chef::CookieCutter::RunState.register
Chef::CookieCutter::SharedBlocks.register
Chef::CookieCutter::SpecMatchers.register
