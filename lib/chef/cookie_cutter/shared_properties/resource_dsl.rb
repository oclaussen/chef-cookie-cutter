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
    module SharedProperties
      ##
      # Extensions to the Chef resource DSL.
      #
      module ResourceDSL
        ##
        # Evaluate a set of properties on the resource.
        # @param name [String, Symbol] The name of a shared property set
        #
        def include_properties(name)
          properties = run_context.shared_properties[name.to_sym]
          if properties.nil?
            Chef::Log.warn("No shared properties with name #{name} exist")
            return
          end
          Chef::Log.warn("Including non-public properties #{name}") if properties.internal?
          properties.eval_on_resource(self)
        end
      end
    end
  end
end
