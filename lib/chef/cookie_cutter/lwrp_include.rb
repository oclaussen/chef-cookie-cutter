# encoding: UTF-8

class Chef
  module CookieCutter
    module LWRPInclude
      module_function

      def build_resource_module_from_file(node, cookbook, segment, name)
        cookbook_version = node.run_context.cookbook_collection[cookbook]
        vendor = ::Chef::Cookbook::FileVendor.create_from_manifest(cookbook_version.manifest)
        manifest_record = cookbook_version.preferred_manifest_record(node, segment.to_s, name)
        filename = vendor.get_filename(manifest_record[:path])

        fail IOError, "Cannot open or read #{filename}" unless File.exist?(filename) && File.readable?(filename)

        resource_module = Module.new
        resource_module.instance_variable_set('@filename', filename)
        def resource_module.included(cls)
          cls.class_eval(IO.read(@filename), @filename, 1)
        end
        resource_module
      end
    end

    module ResourceDSL
      def lwrp_include(name, cookbook:)
        include ::Chef::CookieCutter::LWRPInclude.build_resource_module_from_file(node, cookbook, :resources, name)
      end
    end
    # TODO: doesn't work
    # module ProviderDSL
    #   def lwrp_include(name, cookbook: 'dotfiles')
    #     include ::Chef::CookieCutter::LWRPInclude.build_resource_module_from_file(node, cookbook, :providers, name)
    #   end
    # end
  end
end
