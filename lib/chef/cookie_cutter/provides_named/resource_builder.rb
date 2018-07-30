# frozen_string_literal: true

class Chef
  module CookieCutter
    module ProvidesNamed
      # @!visibility private
      module ResourceBuilder
        def build(&block)
          run_context.instance_variable_set :@resource_builder, self
          super(&block)
        end
      end
    end
  end
end
