# encoding: UTF-8
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
require 'chef/cookie_cutter/namespace/namespace'

class Chef
  module CookieCutter
    module Namespace
      module MonkeyPatches
        module Node
          def namespace(*args, **kwargs, &blk)
            @namespace_options = namespace_options.merge(kwargs)
            keys = args.map(&:to_s)
            @current_namespace = current_namespace + keys
            instance_eval(&blk) if block_given?
            @current_namespace = current_namespace - keys
            @namespace_options = nil if @current_namespace.empty?
            nil
          end

          def method_missing(method_name, *args)
            super
          rescue NoMethodError
            if args.empty?
              deep_key = current_namespace.dup << method_name.to_s
              return Namespace.deep_fetch(attributes, deep_key)
            else
              vivified[method_name.to_s] = args.size == 1 ? args.first : args
              return nil
            end
          end

          private

          def namespace_options
            @namespace_options ||= { precedence: default }
          end

          def current_namespace
            @current_namespace ||= []
          end

          def vivified
            precedence = namespace_options[:precedence]
            current_namespace.inject(precedence) do |hash, item|
              hash[item] ||= {}
              hash[item]
            end
          end
        end
      end
    end
  end
end
