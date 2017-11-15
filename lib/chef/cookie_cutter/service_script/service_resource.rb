# frozen_string_literal: true

#
# Copyright 2017, Ole Claussen <claussen.ole@gmail.com>
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
