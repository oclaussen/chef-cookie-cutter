# encoding: UTF-8

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

    module DSL
      def namespace(*args)
        keys = args.map(&:to_s)
        attribute = ::Chef::CookieCutter::Namespace.deep_fetch(node.attributes, keys)
        yield attribute if block_given?
      end
    end
  end

  class Node
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

    def method_missing(method_name, *args)
      attributes.send(method_name, *args)
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
