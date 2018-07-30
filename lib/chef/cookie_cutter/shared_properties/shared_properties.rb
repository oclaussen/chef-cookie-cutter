# frozen_string_literal: true

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
