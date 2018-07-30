# frozen_string_literal: true

class Chef
  module CookieCutter
    module SharedProperties
      # @!visibility private
      module RunContext
        def shared_properties
          @shared_properties ||= {}
        end
      end
    end
  end
end
