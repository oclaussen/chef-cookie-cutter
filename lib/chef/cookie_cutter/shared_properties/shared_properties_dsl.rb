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
    module SharedProperties
      ##
      # DSL for shared properties files.
      #
      module SharedPropertiesDSL
        ##
        # Set the name of this set of properties. This name must be unique
        # across all cookbooks in the run list. Resources can include these
        # properties by this name.
        #
        # @param properties_name [String, Symbol] the new name of the property set
        #
        def share_as(properties_name)
          self.name = properties_name
        end

        ##
        # Define a before block. This block will be evaluated before all other
        # blocks of this property set, and can be used, for example, to set some
        # variables on the resource.
        #
        def before(&blk)
          self.before_block = blk
        end

        ##
        # Define a block that should always be evaluated on the resource,
        # regardless of resource name. See #in_resource for details.
        #
        def always(&blk)
          self.always_block = blk
        end

        ##
        # Define a block that should only be evaluated, if no block specific for
        # the resource was found. See #in_resource for details.
        #
        def otherwise(&blk)
          self.otherwise_block = blk
        end

        ##
        # Define a block that should only be evaluated, if this property set is
        # included in a resource with one of the given names.
        #
        # @param names [List<Symbol>] names of the resources on which this block should be evaluated.
        #
        def in_resource(*names, &blk)
          names.each do |name|
            blocks[name.to_sym] = blk
          end
        end

        ##
        # Mark this property set as *internal*, i.e. private to this cookbook.
        # Internal property sets show a warning when included from any other
        # cookbook.
        #
        # @param set_internal [TrueClass, FalseClass] whether the property set is internal
        #
        def internal(set_internal = true)
          @internal = set_internal
        end

        ##
        # Check if the property set have been marked as #internal.
        #
        # @return [TrueClass, FalseClass] true iff the property set has been marked as internal
        #
        def internal?
          @internal ||= false
        end
      end
    end
  end
end
