# frozen_string_literal: true

class Chef
  module CookieCutter
    module SpecMatchers
      # @!visibility private
      module MonkeyPatches
        # Monkey Patches for Chef::Resource::LWRPBase
        # Automatically registers chef spec matchers after building the resource
        module CustomResource
          module ClassMethods
            def build_from_file(cookbook_name, filename, run_context)
              resource = super
              if defined?(ChefSpec) && !resource.is_a?(TrueClass)
                resource.actions.each do |action|
                  Object.send :define_method, "#{action}_#{resource.resource_name}" do |msg|
                    ::ChefSpec::Matchers::ResourceMatcher.new(resource.resource_name, action, msg)
                  end
                end
              end
              resource
            end
          end

          def self.prepended(base)
            class << base
              prepend ClassMethods
            end
          end
        end
      end
    end
  end
end
