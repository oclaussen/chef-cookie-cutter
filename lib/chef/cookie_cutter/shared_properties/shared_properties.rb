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

class Chef
  module CookieCutter
    module SharedProperties
      # @!visibility private
      class SharedProperties
        include Chef::Mixin::FromFile

        class << self
          include Chef::Mixin::ConvertToClassName

          def build_from_file(cookbook_name, filename)
            properties_name = filename_to_qualified_string cookbook_name, filename
            properties = SharedProperties.new properties_name
            properties.from_file filename
            Chef::Log.debug "Loaded contents of #{filename} into shared properties #{properties_name}"
            properties
          end
        end

        attr_reader :name
        attr_reader :otherwise_block
        attr_reader :always_block
        attr_reader :before_block

        def initialize(name)
          @name = name.to_sym
          @blocks = {}
        end

        def share_as(name)
          @name = name
        end

        def before(&blk)
          @before_block = blk
        end

        def always(&blk)
          @always_block = blk
        end

        def otherwise(&blk)
          @otherwise_block = blk
        end

        def in_resource(*names, &blk)
          names.each do |name|
            @blocks[name.to_sym] = blk
          end
        end

        def block_for_resource(resource_name)
          @blocks[resource_name]
        end
      end
    end
  end
end
