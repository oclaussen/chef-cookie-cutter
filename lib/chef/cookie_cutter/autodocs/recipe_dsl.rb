# encoding: UTF-8
#
# Copyright 2015, Ole Claussen <claussen.ole@gmail.com>
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
      module RecipeDSL
        def description(text = nil)
          @description = text unless text.nil?
          return @description unless @description.nil?
          recipes = run_context.cookbook_collection[cookbook_name].metadata.recipes
          recipe, _cookbook = Recipe.parse_recipe_name recipe_name, current_cookbook: cookbook_name
          full_name = "#{cookbook_name}::#{recipe}"
          return recipes[full_name] if recipes.key?(full_name)
          return recipes[recipe] if recipes.key?(recipe)
          ''
        end

        def short_description
          match = Regexp.new('^(.*?\.(\z|\s))', Regexp::MULTILINE).match(description)
          return description if match.nil?
          match[1]
        end
      end
    end
  end
end
