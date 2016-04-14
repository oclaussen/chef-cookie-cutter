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

class Chef
  module CookieCutter
    module ServiceScript
      module SysvinitProvider
        def script_path
          "/etc/init.d/#{new_resource.service_name}"
        end

        def pid_file
          "/var/run/#{new_resource.service_name}.pid"
        end

        def template_source
          'sysvinit.sh.erb'
        end

        def pid
          IO.read(pid_file).to_i if ::File.exist?(pid_file)
        end

        def create_service
          res = super
          parts = new_resource.command.split(/ /, 2)
          daemon = ENV['PATH']
                   .split(/:/)
                   .map { |path| ::File.absolute_path(parts[0], path) }
                   .find { |path| ::File.exist?(path) } || parts[0]
          res.variables.update(
            daemon: daemon,
            daemon_options: parts[1].to_s,
            pid_file: pid_file
          )
        end

        def delete_service
          super
          Chef::Resource::File.new(pid_file, run_context).run_action(:delete)
        end
      end
    end
  end
end
