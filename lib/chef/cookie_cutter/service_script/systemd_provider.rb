# frozen_string_literal: true

require 'mixlib/shellout'

class Chef
  module CookieCutter
    module ServiceScript
      module SystemdProvider
        def script_path
          "/etc/systemd/system/#{new_resource.service_name}.service"
        end

        def template_source
          'systemd.service.erb'
        end

        def pid
          cmd = Mixlib::Shellout.new("systemctl status #{new_resource.service_name}")
          return nil if cmd.error?
          return nil unless cmd.stdout.include?('Active: active (running)')
          match = cmd.stdout.match(/Main PID: (\d+)/)
          return nil unless match
          match[1].to_i
        end
      end
    end
  end
end
