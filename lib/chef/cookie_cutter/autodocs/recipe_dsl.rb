# frozen_string_literal: true

#
# Copyright 2017, Ole Claussen <claussen.ole@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
