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
    module FancyPropertyModule
      module MonkeyPatches
        # Monkey Patches for KnifeCookbookDoc::ResourceModel
        # Enriches attribute/property description with additional info
        # if certain options are passed to FancyProperty
        # Removes argument declaration from description if present, and makes
        # it available accessor
        module DocumentResourceModel
          ARGS_REGEX = /@args\s*\(([^\(\)]+)\)\s*(.*)/

          def attribute_description(attribute)
            description = attribute_descriptions[attribute.to_s] || ''
            description = ARGS_REGEX.match(description)[2] if description =~ ARGS_REGEX
            opts = @native_resource.attribute_specifications[attribute]
            description += " Must be a `#{opts[:coerce_resource]}` resource or a block." if opts.key?(:coerce_resource)
            description += ' This attribute can be specified multiple times.' if opts.key?(:collect)
            description
          end

          def attribute_arguments(attribute)
            description = attribute_descriptions[attribute.to_s]
            return [] unless description =~ ARGS_REGEX
            ARGS_REGEX.match(description)[1].split(',').map(&:strip)
          end
        end
      end
    end
  end
end
