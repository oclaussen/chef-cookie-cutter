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

require 'mixlib/shellout'

class Chef
  module CookieCutter
    module ServiceScript
      module UpstartProvider
        def script_path
          "/etc/init/#{new_resource.service_name}.conf"
        end

        def template_source
          'upstart.conf.erb'
        end

        def pid
          cmd = Mixlib::Shellout.new("initctl status #{new_resource.service_name}")
          return nil if cmd.error?
          match = cmd.stdout.match(/process (\d+)/)
          return nil unless match
          match[1].to_i
        end
      end
    end
  end
end
