# encoding: UTF-8

class Chef
  module CookieCutter
    module RunState
      module_function

      class RunStateDoesNotExistError < StandardError
        def initialize(keys, key)
          hash = keys.map { |k| "['#{k}']" }
          super <<-EOH
The run_state does not contain an element at run_state#{hash.join}.
Specifically, #{key} is not defined.
EOH
        end
      end

      def store_state(node, *subkeys, key, value)
        subkeys.map!(&:to_s)
        hash = node.run_state
        subkeys.each do |k|
          hash[k] = {} if hash[k].nil?
          hash = hash[k]
        end
        hash[key.to_s] = value
      end

      def fetch_state(node, *keys)
        keys.map!(&:to_s)
        keys.inject(node.run_state) do |hash, key|
          fail ::Chef::CookieCutter::RunState::RunStateDoesNotExistError.new(keys, key) unless hash.key? key
          hash[key]
        end
      end
    end

    module DSL
      def store_state(*subkeys, key, value)
        ::Chef::CookieCutter::RunState.store_state(node, *subkeys, key, value)
      end

      def fetch_state(*keys)
        ::Chef::CookieCutter::RunState.fetch_state(node, *keys)
      end

      def exist_state?(*keys)
        ::Chef::CookieCutter::RunState.fetch_state(node, *keys)
        true
      rescue ::Chef::CookieCutter::RunState::RunStateDoesNotExistError
        false
      end
    end
  end
end
