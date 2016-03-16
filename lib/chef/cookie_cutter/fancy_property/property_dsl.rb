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
    module FancyProperty
      # @!visibility private
      module PropertyDSL
        def call(resource, *args, **kwargs, &blk)
          return get(resource) if args.empty? && kwargs.empty? && !block_given?
          return get(resource) if args[0] == NOT_PASSED
          set(resource, *args, **kwargs, &blk)
        end

        def set(resource, *args, **kwargs, &blk)
          if args[0].is_a?(DelayedEvaluator)
            set_value(resource, args[0])
          else
            value = coerce(resource, *args, **kwargs, &blk)
            validate(resource, value)
            set_value(resource, value)
          end
        end

        def coerce(resource, *args, **kwargs, &blk)
          if options.key?(:coerce_class)
            raise Chef::Exceptions::CannotValidateStaticallyError unless resource
            value = coerce_class(options[:coerce_class], *args, **kwargs, &blk)
            value = coerce_proc(resource, options[:coerce], value) if options.key?(:coerce)
            value
          elsif options.key?(:coerce_resource)
            raise Chef::Exceptions::CannotValidateStaticallyError unless resource
            value = coerce_resource(resource, options[:coerce_resource], args[0], &blk)
            # We need to initialize empty args and kwargs here, because otherwise
            # the resource will be transformed into a hash and put on the kwargs
            # slot. Ruby is weird that way.
            args = []
            kwargs = {}
            value = coerce_proc(resource, options[:coerce], value, *args, **kwargs) if options.key?(:coerce)
            value
          elsif options.key?(:coerce)
            raise Chef::Exceptions::CannotValidateStaticallyError unless resource
            coerce_proc(resource, options[:coerce], *args, **kwargs, &blk)
          elsif args.empty?
            kwargs
          elsif args.length == 1
            args[0]
          else
            args
          end
        end

        def coerce_class(clazz, *args, **kwargs, &blk)
          if clazz.is_a?(Proc)
            target = Class.new
            target.class_eval(&clazz)
          else
            target = clazz
          end
          args << kwargs unless kwargs.empty?
          value = target.new(*args)
          value.instance_eval(&blk) if block_given?
          value
        end

        def coerce_resource(resource, resource_type, value, &blk)
          return value if value.is_a?(::Chef::Resource) && value.declared_type == resource_type
          new_resource = ::Chef::ResourceBuilder.new(
            type: resource_type,
            name: value,
            created_at: caller[0],
            params: nil,
            run_context: resource.run_context,
            cookbook_name: resource.cookbook_name,
            recipe_name: resource.recipe_name,
            enclosing_provider: nil
          ).build(&blk)
          resource.run_context.resource_collection.insert(
            new_resource,
            resource_type: resource_type,
            instance_name: value
          )
          new_resource
        end

        def coerce_proc(resource, coerce, *args, **kwargs, &blk)
          args << kwargs unless kwargs.empty?
          value = resource.instance_exec(*args, &coerce) unless resource.nil?
          value.instance_eval(&blk) if block_given?
          value = coerce(resource, value) if value.is_a?(DelayedEvaluator)
          value
        end

        def emit_dsl
          return unless instance_variable_name

          if allow_kwargs?
            declared_in.class_eval <<-EOM, __FILE__, __LINE__ + 1
              def #{name}(*args, **kwargs, &blk)
                self.class.properties[#{name.inspect}].call(self, *args, **kwargs, &blk)
              end
            EOM
          else
            declared_in.class_eval <<-EOM, __FILE__, __LINE__ + 1
              def #{name}(value=NOT_PASSED, &blk)
                self.class.properties[#{name.inspect}].call(self, value, {}, &blk)
              end
              def #{name}=(value)
                self.class.properties[#{name.inspect}].set(self, value, {})
              end
            EOM
          end
        end

        def allow_kwargs?
          return true if options[:allow_kwargs]
          return true if options.key?(:coerce) && options[:coerce].arity != 1
          return true if options.key?(:coerce_class)
          false
        end

        def validation_options
          super.delete_if { |k, _| [:allow_kwargs, :coerce_class, :coerce_resource].include?(k) }
        end
      end
    end
  end
end
