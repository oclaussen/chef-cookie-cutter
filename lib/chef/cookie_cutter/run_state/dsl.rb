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
require 'chef/cookie_cutter/run_state/errors'

class Chef
  module CookieCutter
    module RunState
      module DSL
        def store_state(*subkeys, key, value)
          subkeys.map!(&:to_s)
          hash = node.run_state
          subkeys.each do |k|
            hash[k] = {} if hash[k].nil?
            hash = hash[k]
          end
          hash[key.to_s] = value
        end

        def fetch_state(*keys)
          keys.map!(&:to_s)
          keys.inject(node.run_state) do |hash, key|
            raise Errors::RunStateDoesNotExistError.new(keys, key) unless hash.key? key
            hash[key]
          end
        end

        def exist_state?(*keys)
          fetch_state(*keys)
          true
        rescue Errors::RunStateDoesNotExistError
          false
        end
      end
    end
  end
end
