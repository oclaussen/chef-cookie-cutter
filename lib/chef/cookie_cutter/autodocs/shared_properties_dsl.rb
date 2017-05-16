# encoding: UTF-8
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
