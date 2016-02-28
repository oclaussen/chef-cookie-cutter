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
require 'chef/run_context'
require 'chef/resource_builder'

class Chef
  module CookieCutter
    ##
    # Makes the `ResourceBuilder` that is used to resolve the current resource
    # available in the run context. This way it can be read, for example, in the
    # block parameter for `Resource.provides`.
    #
    # @example File my_cookbook/resources/test.rb
    #   provides :fancy_resource_name do |node|
    #     node.run_context.resource_builder.name =~ /test/
    #   end
    #
    module ExtendedProvides
      require 'chef/cookie_cutter/extended_provides/monkey_patches'

      ::Chef::RunContext.send :prepend, MonkeyPatches::RunContext
      ::Chef::ResourceBuilder.send :prepend, MonkeyPatches::ResourceBuilder
    end
  end
end
