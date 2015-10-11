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
require 'chef/property'

class Chef
  module CookieCutter
    class FancyProperty < ::Chef::Property
      def call(resource, *args, **kwargs, &blk)
        return get(resource) if args.empty? && kwargs.empty? && !block_given?
        set(resource, *args, **kwargs, &blk)
      end

      def get(resource)
        if instance_variable_name && collect? && !is_set?(resource)
          []
        else
          super
        end
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
        if options.key?(:coerce_class) && options.key?(:coerce)
          value = coerce_class(options[:coerce_class], *args, **kwargs, &blk)
          value = coerce_proc(resource, options[:coerce], value)
          value
        elsif options.key?(:coerce_class)
          coerce_class(options[:coerce_class], *args, **kwargs, &blk)
        elsif options.key?(:coerce)
          coerce_proc(resource, options[:coerce], *args, **kwargs, &blk)
        elsif args.length == 1 && kwargs.empty?
          args[0]
        else
          fail Chef::Exceptions::ValidationFailed, "No coercion given for arguments #{args}, #{kwargs}"
        end
      end

      def coerce_class(clazz, *args, **kwargs, &blk)
        value = clazz.new(*args, **kwargs)
        value.instance_eval(&blk) if block_given?
        value
      end

      def coerce_proc(resource, coerce, *args, **kwargs, &blk)
        value = resource.instance_exec(*args, **kwargs, &coerce) unless resource.nil?
        value.instance_eval(&blk) if block_given?
        value = coerce(resource, value) if value.is_a?(DelayedEvaluator)
        value
      end

      def emit_dsl
        return unless instance_variable_name
        # Holy shit, this looks evil. But Chef does it the same way so yeah.
        declared_in.class_eval <<-EOM, __FILE__, __LINE__ + 1
          def #{name}(*args, **kwargs, &blk)
            self.class.properties[#{name.inspect}].call(self, *args, **kwargs, &blk)
          end
        EOM
      end

      def collect?
        options[:collect]
      end

      def validation_options
        @validation_options ||= options.reject do |k, _|
          [
            :declared_in, :name, :instance_variable_name, :desired_state,
            :identity, :default, :name_property, :coerce, :required, :collect,
            :coerce_class
          ].include?(k)
        end
      end

      def set_value(resource, value)
        if instance_variable_name && collect?
          resource.instance_variable_set(instance_variable_name, []) unless is_set?(resource)
          get_value(resource) << value
        else
          super
        end
      end
    end
  end
end
