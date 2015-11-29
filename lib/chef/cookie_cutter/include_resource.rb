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

class Chef
  module CookieCutter
    module IncludeResource
      module_function

      # rubocop:disable Style/GuardClause
      def register
        Chef::Resource::LWRPBase.send :extend, ResourceDSL
        Chef::Resource::LWRPBase.send :prepend, MonkeyPatches::CustomResource
        if defined?(DocumentingLWRPBase)
          DocumentingLWRPBase.send :extend, DocumentingResourceDSL
          DocumentingLWRPBase.send :extend, FakeResource
        end
        if defined?(KnifeCookbookDoc)
          KnifeCookbookDoc::ReadmeModel.send :prepend, MonkeyPatches::DocumentReadmeModel
          KnifeCookbookDoc::ResourceModel.send :prepend, MonkeyPatches::DocumentResourceModel
        end
      end

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

      module ResourceDSL
        def include_resource(name, cookbook: nil)
          cookbook = resource_cookbook_name if cookbook.nil?
          filename = IncludeResource.filename_for_record(run_context, cookbook, :resources, name)
          include IncludeResource.build_resource_module_from_file(filename)
        end
      end

      module DocumentingResourceDSL
        def mixins
          @mixins ||= []
        end

        def include_resource(name, cookbook: nil)
          mixins << { name: name, cookbook: cookbook }
        end
      end

      module MonkeyPatches
        # Monkey Patches for Chef::Resource::LWRPBase
        # Makes the parameters of build_from_file (i.e. cookbook_name, filename
        # and run_context) available in the created class.
        module CustomResource
          module ClassMethods
            def build_from_file(cookbook_name, filename, run_context)
              define_singleton_method(:resource_cookbook_name) { cookbook_name }
              super
            end
          end

          def self.prepended(base)
            class << base
              prepend ClassMethods
            end
          end
        end

        # Monkey Patches for KnifeCookbookDoc::ReadmeModel
        # Additionally searches for resource files in sub directories in addition.
        # Adds getter for mixin resources.
        module DocumentReadmeModel
          def initialize(cookbook_dir, constraints)
            super
            Dir["#{cookbook_dir}/resources/*/**/*.rb"].sort.each do |resource_filename|
              @resources << ::KnifeCookbookDoc::ResourceModel.new(@metadata.name, resource_filename)
            end
          end

          def resources
            @resources.reject(&:mixin?)
          end

          def mixin_resources
            @resources.select(&:mixin?)
          end
        end

        # Monkey Patches for KnifeCookbookDoc::ResourceModel
        # Overwrites load_descriptions to additionally check if a resource is a mixin.
        # Saves cookbook and file name in instance variables
        module DocumentResourceModel
          def initialize(cookbook_name, file)
            @cookbook_name = cookbook_name
            @file = file
            super
          end

          def name
            return filename_to_qualified_string(@cookbook_name, @file) if mixin?
            super
          end

          def mixin?
            @mixin
          end

          def mixins
            @native_resource.mixins.map do |mixin|
              mixin[:cookbook] = @cookbook_name if mixin[:cookbook].nil?
              filename_to_qualified_string(mixin[:cookbook], mixin[:name])
            end
          end

          # rubocop:disable Style/PerlBackrefs
          def load_descriptions
            current_section = 'main'
            @native_resource.description.each_line do |line|
              if /^ *\@action *([^ ]*) (.*)$/ =~ line
                action_descriptions[$1] = $2.strip
              elsif /^ *(?:\@attribute|\@property) *([^ ]*) (.*)$/ =~ line
                attribute_descriptions[$1] = $2.strip
              elsif /^ *\@section (.*)$/ =~ line
                current_section = $1.strip
              elsif /^ *\@mixin(.*)$/ =~ line
                @mixin = true
              else
                lines = (top_level_descriptions[current_section] || [])
                lines << line.delete("\n")
                top_level_descriptions[current_section] = lines
              end
            end
          end
        end
      end
    end
  end
end
