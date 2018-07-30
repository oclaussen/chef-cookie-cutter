# frozen_string_literal: true

require 'chef/cookie_cutter/ohai_helpers'

class Chef
  module CookieCutter
    module ServiceScript
      module ServiceResource
        def self.included(service)
          service.instance_eval do
            property :command,
                     String,
                     required: true

            property :user,
                     String,
                     default: 'root'

            property :directory,
                     String,
                     default: lazy { node.user_home(user == 'root' ? nil : user) }

            property :environment,
                     Hash,
                     default: lazy { Mash.new }

            property :stop_signal,
                     [String, Symbol, Integer],
                     default: 'TERM',
                     coerce: proc { |sig|
                       next Signal.signame(sig) if sig.is_a?(Integer)
                       sig.to_s.upcase.gsub(/^SIG/, '')
                     },
                     callbacks: {
                       'Must be a valid signal' => Signal.list.method(:include?)
                     }

            property :reload_signal,
                     [String, Symbol, Integer],
                     default: 'HUP',
                     coerce: proc { |sig|
                       next Signal.signame(sig) if sig.is_a?(Integer)
                       sig.to_s.upcase.gsub(/^SIG/, '')
                     },
                     callbacks: {
                       'Must be a valid signal' => Signal.list.method(:include?)
                     }

            property :restart_on_update,
                     [true, false, :immediately, 'immediately'],
                     default: true
          end
        end

        def pid
          provider_for_action(:pid).pid
        end
      end
    end
  end
end
