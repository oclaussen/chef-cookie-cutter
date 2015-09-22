# encoding: UTF-8

require 'chef/property'

class Chef
  module CookieCutter
    class FancyProperty < ::Chef::Property
      def call(resource, *args, **kwargs, &blk)
        return get(resource) if args.empty? && kwargs.empty?
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
        if options.key?(:coerce_class)
          value = options[:coerce_class].new(*args, **kwargs)
          value.instance_eval(&blk) if block_given?
          value
        elsif options.key?(:coerce)
          value = resource.instance_exec(*args, **kwargs, &options[:coerce]) unless resource.nil?
          value.instance_eval(&blk) if block_given?
          value = coerce(resource, value) if value.is_a?(DelayedEvaluator)
          value
        elsif args.length == 1 && kwargs.empty?
          args[0]
        else
          fail Chef::Exceptions::ValidationFailed, "No coercion given for arguments #{args}, #{kwargs}"
        end
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
