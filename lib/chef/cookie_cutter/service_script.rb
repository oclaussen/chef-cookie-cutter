# frozen_string_literal: true

require 'chef/resource/service'
require 'chef/provider/service'
require 'chef/provider/service/simple'
require 'chef/provider/service/init'
require 'chef/provider/service/systemd'
require 'chef/provider/service/upstart'

class Chef
  module CookieCutter
    module ServiceScript
      require 'chef/cookie_cutter/service_script/service_resource'
      require 'chef/cookie_cutter/service_script/simple_provider'
      require 'chef/cookie_cutter/service_script/systemd_provider'
      require 'chef/cookie_cutter/service_script/sysvinit_provider'
      require 'chef/cookie_cutter/service_script/upstart_provider'

      ::Chef::Resource::Service.send :include, ServiceResource
      ::Chef::Provider::Service::Simple.send :prepend, SimpleProvider
      ::Chef::Provider::Service::Init.send :prepend, SysvinitProvider
      ::Chef::Provider::Service::Systemd.send :prepend, SystemdProvider
      ::Chef::Provider::Service::Upstart.send :prepend, UpstartProvider
    end
  end
end
