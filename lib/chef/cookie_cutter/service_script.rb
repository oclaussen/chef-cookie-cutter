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
