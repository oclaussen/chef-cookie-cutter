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
          if hash.key?(key)
            hash[key]
          else
            fail ::Chef::CookieCutter::Namespace::AttributeDoesNotExistError.new(keys, key)
          end
        end
      end
    end

    module AttributeDSL
      def namespace(*args, **kwargs, &blk)
        @namespace_options ||= { precedence: default }
        @namespace_options = @namespace_options.merge(kwargs)
        keys = args.map(&:to_s)
        @current_namespace ||= []
        @current_namespace += keys
        instance_eval(&blk) if block_given?
        @current_namespace -= keys
        @namespace_options = nil if @current_namespace.empty?
        nil
      end
    end

    module DSL
      def namespace(*args)
        keys = args.map(&:to_s)
        attribute = ::Chef::CookieCutter::Namespace.deep_fetch(node.attributes, keys)
        yield attribute if block_given?
      end
    end

    module MonkeyPatches
      module Node
        def method_missing(method_name, *args)
          super
        rescue NoMethodError
          @current_namespace ||= []
          @namespace_options ||= { precedence: default }
          if args.empty?
            deep_key = @current_namespace.dup << method_name.to_s
            return ::Chef::CookieCutter::Namespace.deep_fetch!(attributes, deep_key)
          else
            vivified = @current_namespace.inject(@namespace_options[:precedence]) do |hash, item|
              hash[item] ||= {}
              hash[item]
            end
            vivified[method_name.to_s] = args.size == 1 ? args.first : args
            return nil
          end
        end
      end
    end
  end
end
