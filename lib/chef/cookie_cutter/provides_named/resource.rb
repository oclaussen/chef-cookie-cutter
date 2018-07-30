# frozen_string_literal: true

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
