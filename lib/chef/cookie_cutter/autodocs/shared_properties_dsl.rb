# frozen_string_literal: true

class Chef
  module CookieCutter
    module Autodocs
      ##
      # Extensions to the shared properties DSL
      #
      module SharedPropertiesDSL
        ##
        # Get or set a description for the shared properties.
        #
        # @param text [String] if given, will set the description of the properties to this text
        # @return [String] the description of the recipe
        #
        def description(text = nil)
          @description = text unless text.nil?
          return @description unless @description.nil?
          ''
        end

        ##
        # Get a short description for the shared properties. The short
        # description is simply the first full sentence of the normal
        # #description.
        #
        # @return [String] the first sentence of the description
        #
        def short_description
          match = Regexp.new('^(.*?\.(\z|\s))', Regexp::MULTILINE).match(description)
          return description if match.nil?
          match[1].tr("\n", ' ').strip
        end
      end
    end
  end
end
