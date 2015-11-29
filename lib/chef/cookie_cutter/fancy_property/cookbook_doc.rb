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
        module DocumentResourceModel
          def attribute_description(attribute)
            description = super || ''
            opts = @native_resource.attribute_specifications[attribute]
            description += " Must be a `#{opts[:coerce_resource]}` resource or a block." if opts.key?(:coerce_resource)
            description += ' This attribute can be specified multiple times.' if opts.key?(:collect)
            description
          end
        end
      end
    end
  end
end
