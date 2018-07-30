# frozen_string_literal: true

class Chef
  module CookieCutter
    module IncludeResource
      # @!visibility private
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
    end
  end
end
