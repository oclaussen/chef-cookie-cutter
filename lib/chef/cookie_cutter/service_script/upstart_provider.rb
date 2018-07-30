# frozen_string_literal: true

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
