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

require 'chef/cookie_cutter/shared_properties/shared_properties'

class Chef
  module CookieCutter
    module SharedProperties
      # @!visibility private
      module CookbookCompiler
        def compile
          compile_libraries
          compile_attributes
          compile_shared_properties
          compile_lwrps
          compile_resource_definitions
          compile_recipes
        end

        def compile_shared_properties
          # @events.shared_properties_load_start(count_files_by_segment(:shared_properties))
          cookbook_order.each do |cookbook|
            load_shared_properties_from_cookbook(cookbook)
          end
          # @events.shared_properties_load_complete
        end

        def load_shared_properties_from_cookbook(cookbook_name)
          load_shared_properties_files(cookbook_name).each do |filename|
            load_shared_properties(cookbook_name, filename)
          end
        end

        def load_shared_properties_files(cookbook_name)
          # fix this once we can create our own segments
          cookbook = cookbook_collection[cookbook_name]
          cookbook.relative_filenames_in_preferred_directory(node, :files, 'shared_properties').map do |file|
            relative_file = ::File.join('default', 'shared_properties', file)
            cookbook.preferred_filename_on_disk_location(node, :files, relative_file)
          end
        rescue Chef::Exceptions::FileNotFound
          []
        end

        def load_shared_properties(cookbook_name, filename)
          Chef::Log.debug("Loading cookbook #{cookbook_name}'s shared properties from #{filename}")
          properties = Chef::CookieCutter::SharedProperties::SharedProperties.build_from_file(cookbook_name, filename)
          @run_context.shared_properties[properties.name] = properties
          # @events.shared_properties_loaded(filename)
        rescue
          # @events.shared_properties_load_failed(filename, e)
          raise
        end
      end
    end
  end
end
