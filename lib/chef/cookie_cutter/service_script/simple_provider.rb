# frozen_string_literal: true

class Chef
  module CookieCutter
    module ServiceScript
      module SimpleProvider
        def restart_on_update
          return false unless new_resource.restart_on_update
          return false unless ::File.exist?(script_path)
          return :immediately if new_resource.restart_on_update == :immediately
          return :immediately if new_resource.restart_on_update == 'immediately'
          :delayed
        end

        def action_enable
          create_service
          super
        end

        def action_disable
          delete_service
          super
        end

        def create_service
          res = Chef::Resource::Template.new(script_path, run_context)
          res.owner 'root'
          res.group 'root'
          res.mode '644'
          res.source template_source
          res.cookbook 'cookie-cutter'
          res.variables(
            name: new_resource.service_name,
            user: new_resource.user,
            command: new_resource.command,
            directory: new_resource.directory,
            environment: new_resource.environment,
            reload_signal: new_resource.reload_signal,
            stop_signal: new_resource.stop_signal
          )
          res.notifies :restart, new_resource, restart_on_update if restart_on_update
          res.run_action :create
          res
        end

        def delete_service
          Chef::Resource::File.new(script_path, run_context).run_action(:delete)
        end
      end
    end
  end
end
