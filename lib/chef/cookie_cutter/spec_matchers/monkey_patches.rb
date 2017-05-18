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
    module SpecMatchers
      # @!visibility private
      module MonkeyPatches
        # Monkey Patches for Chef::Resource::LWRPBase
        # Automatically registers chef spec matchers after building the resource
        module CustomResource
          module ClassMethods
            def build_from_file(cookbook_name, filename, run_context)
              resource = super
              if defined?(ChefSpec) && !resource.is_a?(TrueClass)
                resource.actions.each do |action|
                  Object.send :define_method, "#{action}_#{resource.resource_name}" do |msg|
                    ::ChefSpec::Matchers::ResourceMatcher.new(resource.resource_name, action, msg)
                  end
                end
              end
              resource
            end
          end

          def self.prepended(base)
            class << base
              prepend ClassMethods
            end
          end
        end
      end
    end
  end
end
