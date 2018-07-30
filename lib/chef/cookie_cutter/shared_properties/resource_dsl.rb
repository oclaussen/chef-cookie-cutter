# frozen_string_literal: true

class Chef
  module CookieCutter
    module SharedProperties
      ##
      # Extensions to the Chef resource DSL.
      #
      module ResourceDSL
        ##
        # Evaluate a set of properties on the resource.
        # @param name [String, Symbol] The name of a shared property set
        #
        def include_properties(name)
          properties = run_context.shared_properties[name.to_sym]
          if properties.nil?
            Chef::Log.warn("No shared properties with name #{name} exist")
            return
          end
          Chef::Log.warn("Including non-public properties #{name}") if properties.internal?
          properties.eval_on_resource(self)
        end
      end
    end
  end
end
