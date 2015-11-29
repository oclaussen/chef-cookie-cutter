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
require 'chef/cookbook/file_vendor'

class Chef
  module CookieCutter
    module IncludeResource
      module_function

      def try_file(filename)
        return if File.exist?(filename) && File.readable?(filename)
        fail IOError, "Cannot open or read #{filename}"
      end

      def filename_for_record(run_context, cookbook_name, segment, name)
        name += '.rb' unless name.end_with?('.rb')
        cookbook_version = run_context.cookbook_collection[cookbook_name]
        file_vendor = ::Chef::Cookbook::FileVendor.create_from_manifest(cookbook_version.manifest)
        manifest_record = cookbook_version.preferred_manifest_record(run_context.node, segment.to_s, name)
        file_vendor.get_filename(manifest_record[:path])
      end

      def build_resource_module_from_file(filename)
        try_file(filename)
        resource_module = Module.new
        resource_module.instance_variable_set('@filename', filename)
        def resource_module.included(cls)
          cls.class_eval(IO.read(@filename), @filename, 1)
        end
        resource_module
      end

      module DSL
        def include_resource(name, cookbook: nil)
          cookbook = resource_cookbook_name if cookbook.nil?
          filename = IncludeResource.filename_for_record(run_context, cookbook, :resources, name)
          include IncludeResource.build_resource_module_from_file(filename)
        end
      end
    end
  end
end
