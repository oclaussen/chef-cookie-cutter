# encoding: UTF-8
# frozen_string_literal: true
#
# Copyright 2016, Ole Claussen <claussen.ole@gmail.com>
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
    module ProvidesNamed
      # @!visibility private
      module CustomResource
        module ClassMethods
          def provides(name, named: nil, **options, &block)
            return super(name, **options, &block) if named.nil?
            original_block_given = block_given?
            wrapped_block = lambda do |node|
              # rubocop:disable Performance/RedundantBlockCall
              return false if original_block_given && !block.call(node)
              resource_name = node.run_context.instance_variable_get(:@resource_builder).name
              if named.is_a?(String) || named.is_a?(Symbol)
                resource_name == named
              elsif named.is_a?(Regexp)
                resource_name =~ named
              else
                false
              end
            end
            super(name, **options, &wrapped_block)
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
