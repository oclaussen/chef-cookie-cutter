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
require 'chef/cookbook/file_vendor'

class Chef
  module CookieCutter
    module IncludeResource
      module_function

      ##
      # @!visibility private
      def try_file(filename)
        return if File.exist?(filename) && File.readable?(filename)
        raise IOError, "Cannot open or read #{filename}"
      end

      ##
      # @!visibility private
      def filename_for_record(run_context, cookbook_name, segment, name)
        name += '.rb' unless name.end_with?('.rb')
        cookbook_version = run_context.cookbook_collection[cookbook_name]
        file_vendor = ::Chef::Cookbook::FileVendor.create_from_manifest(cookbook_version)
        manifest_record = cookbook_version.preferred_manifest_record(run_context.node, segment.to_s, name)
        file_vendor.get_filename(manifest_record[:path])
      end

      ##
      # @!visibility private
      def build_resource_module_from_file(filename)
        try_file(filename)
        resource_module = Module.new
        resource_module.instance_variable_set('@filename', filename)
        def resource_module.included(cls)
          cls.class_eval(IO.read(@filename), @filename, 1)
        end
        resource_module
      end

      ##
      # Extensions for the Chef custom resource DSL
      #
      module ResourceDSL
        ##
        # Include an existing resource into this resource. This works analogous
        # to including a module into a ruby class. The name of the resource is a
        # path relative to the resource directroy in the specified cookbook. For
        # example if a file named `my_cookbook/resources/mixins/my_resource.rb`
        # exists in the cookbook, it can be included with the name
        # `mixins/my_resource`.
        #
        # @param name [String] name of the included resource
        # @param cookbook [String] name of the cookbook containing the resource
        #
        def include_resource(name, cookbook: nil)
          cookbook = resource_cookbook_name if cookbook.nil?
          filename = IncludeResource.filename_for_record(run_context, cookbook, :resources, name)
          internal_before_inclusion = internal?
          include IncludeResource.build_resource_module_from_file(filename)

          return if internal_before_inclusion == internal?
          show_warning = internal? && cookbook != resource_cookbook_name
          Chef::Log.warn("Including non-public resource #{name} from #{cookbook}") if show_warning
          internal internal_before_inclusion
        end

        ##
        # Mark this resource as *internal*, i.e. private to this cookbook.
        # Internal resources show a warning when included from any other
        # cookbook.
        #
        # @param set_internal [TrueClass, FalseClass] whether the resoure is internal
        #
        def internal(set_internal = true)
          @internal = set_internal
        end

        ##
        # Check if the resource has been marked as #internal.
        #
        # @return [TrueClass, FalseClass] true iff the resource has been marked as internal
        #
        def internal?
          @internal ||= false
        end
      end
    end
  end
end
