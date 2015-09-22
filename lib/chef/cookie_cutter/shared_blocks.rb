# encoding: UTF-8

class Chef
  module CookieCutter
    module SharedBlocks
      module_function

      class SharedBlockAlreadyDefined < StandardError
        def initialize(name)
          super <<-EOH
A shared block with the name #{name} already exists. Please make sure that
every shared block you define has a unique name.
EOH
        end
      end

      class SharedBlockNotDefined < StandardError
        def initialize(name)
          super <<-EOH
The shared block with the name #{name} is not defined.
EOH
        end
      end
    end

    module DSL
      def shared?(name)
        exist_state?(:dotfiles, :shared_blocks, name)
      end

      def shared(name, &block)
        fail Chef::CookieCutter::SharedBlocks::SharedBlockAlreadyDefined, name if shared? name
        store_state(:dotfiles, :shared_blocks, name, block)
      end

      def include_shared(name)
        fail Chef::CookieCutter::SharedBlocks::SharedBlockNotDefined, name unless shared? name
        block = fetch_state(:dotfiles, :shared_blocks, name)
        instance_eval(&block)
      end
    end
  end
end
