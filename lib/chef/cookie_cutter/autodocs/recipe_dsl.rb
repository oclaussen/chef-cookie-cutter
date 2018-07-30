# frozen_string_literal: true

class Chef
  module CookieCutter
    module Autodocs
      ##
      # Extensions to the Chef recipe DSL.
      #
      module RecipeDSL
        ##
        # Get the simple name of the recipe, without the cookbook name.
        #
        # @return [String] the recipe name
        #
        def name
          match = /(.+)?::(.+)/.match(recipe_name)
          return recipe_name if match.nil?
          match[2]
        end

        ##
        # Get or set a description for the recipe. If no description has been
        # set, this will attempt to find a description in the `metadata.rb`.
        #
        # @param text [String] if given, will set the description of the recipe to this text
        # @return [String] the description of the recipe
        #
        def description(text = nil)
          @description = text unless text.nil?
          return @description unless @description.nil?
          recipes = run_context.cookbook_collection[cookbook_name].metadata.recipes
          return recipes[name] if recipes.key?(name)
          full_name = "#{cookbook_name}::#{name}"
          return recipes[full_name] if recipes.key?(full_name)
          ''
        end

        ##
        # Get a short description for the recipe. The short description is
        # simply the first full sentence of the normal #description.
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
