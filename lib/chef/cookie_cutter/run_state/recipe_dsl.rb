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
    module RunState
      # @!visibility private
      class RunStateDoesNotExistError < StandardError
        def initialize(keys, key)
          hash = keys.map { |k| "['#{k}']" }
          super <<-EOH
The run_state does not contain an element at run_state#{hash.join}.
Specifically, #{key} is not defined.
EOH
        end
      end

      ##
      # Extensions to the Chef recipe DSL.
      #
      module RecipeDSL
        ##
        # Store a value in the run state.
        #
        # @overload store_state(*keys, value)
        #   @param keys [Array<String, Symbol>] the key with which the value is stored
        #   @param value the object to store
        #
        def store_state(*subkeys, key, value)
          subkeys.map!(&:to_s)
          hash = node.run_state
          subkeys.each do |k|
            hash[k] = {} if hash[k].nil?
            hash = hash[k]
          end
          hash[key.to_s] = value
        end

        ##
        # Retrieve a value from the run state.
        #
        # @param keys [Array<String, Symbol>] the key with which the value is stored
        # @return the value stored under the key
        # @raise [RunStateDoesNotExistError] if no value exists with the key
        #
        def fetch_state(*keys)
          keys.map!(&:to_s)
          keys.inject(node.run_state) do |hash, key|
            raise RunStateDoesNotExistError.new(keys, key) unless hash.key? key
            hash[key]
          end
        end

        ##
        # Check if a value is stored in the run state.
        #
        # @param keys [Array<String, Symbol>] The key with which the value is stored
        # @return [TrueClass, FalseClass] true iff a value exists with the key
        #
        def exist_state?(*keys)
          fetch_state(*keys)
          true
        rescue RunStateDoesNotExistError
          false
        end
      end
    end
  end
end