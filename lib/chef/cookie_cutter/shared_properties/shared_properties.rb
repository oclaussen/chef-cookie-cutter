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

require 'chef/cookie_cutter/shared_properties/shared_properties_dsl'

class Chef
  module CookieCutter
    module SharedProperties
      # @!visibility private
      class SharedProperties
        include Chef::CookieCutter::SharedProperties::SharedPropertiesDSL
        include Chef::Mixin::FromFile

        class << self
          include Chef::Mixin::ConvertToClassName

          def build_from_file(cookbook_name, filename)
            properties = SharedProperties.new
            properties.name = filename_to_qualified_string cookbook_name, filename
            properties.from_file filename
            Chef::Log.debug "Loaded contents of #{filename} into shared properties #{properties.name}"
            properties
          end
        end

        attr_accessor :name
        attr_accessor :blocks
        attr_accessor :otherwise_block
        attr_accessor :always_block
        attr_accessor :before_block

        def initialize
          @blocks = {}
        end

        def resource_block(resource)
          blocks[resource.resource_name] || otherwise_block
        end

        def eval_on_resource(resource)
          resource.instance_exec(&before_block) if before_block
          resource.instance_exec(&resource_block(resource)) if resource_block(resource)
          resource.instance_exec(&always_block) if always_block
        end
      end
    end
  end
end
