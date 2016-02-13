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
    module Namespace
      module_function

      class AttributeDoesNotExistError < StandardError
        def initialize(keys, key)
          super <<-EOH
No attribute `node#{keys.map { |k| "['#{k}']" }.join}' exists on the current
node. Specifically the `#{key}' attribute is not defined. Please make sure you
have spelled everything
correctly.
EOH
        end
      end

      def deep_fetch(attributes, keys)
        keys.map!(&:to_s)
        keys.inject(attributes.to_hash) do |hash, key|
          raise AttributeDoesNotExistError.new(keys, key) unless hash.key?(key)
          hash[key]
        end
      end
    end
  end
end
