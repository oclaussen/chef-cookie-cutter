# frozen_string_literal: true

class Chef
  module CookieCutter
    module CollectProperty
      # @!visibility private
      module PropertyDSL
        def get(resource, nil_set: false)
          if instance_variable_name && collect? && !is_set?(resource)
            []
          else
            super
          end
        end

        def set_value(resource, value)
          if instance_variable_name && collect?
            resource.instance_variable_set(instance_variable_name, []) unless is_set?(resource)
            get_value(resource) << value
          else
            super
          end
        end

        def collect?
          options[:collect]
        end

        def validation_options
          super.delete_if { |k, _| [:collect].include?(k) }
        end
      end
    end
  end
end
