# frozen_string_literal: true

class Chef
  module CookieCutter
    module SpecStubs
      ##
      # Changes to the Chef Resource DSL
      #
      module ResourceDSL
        def only_if(command = nil, opts = {}, &blk)
          autostub_command(command, opts)
          super
        end

        def not_if(command = nil, opts = {}, &blk)
          autostub_command(command, opts)
          super
        end

        def autostub_command(command, opts)
          return unless defined?(ChefSpec)
          return if command.nil?
          return unless opts.key?(:stub_with)
          ChefSpec::Macros.stub_command(command).and_return(opts[:stub_with])
        end
      end
    end
  end
end
