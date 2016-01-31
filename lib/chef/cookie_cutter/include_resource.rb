# encoding: UTF-8
#
# Copyright 2015, Ole Claussen <claussen.ole@gmail.com>
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
require 'chef/resource/lwrp_base'

class Chef
  module CookieCutter
    module IncludeResource
      require 'chef/cookie_cutter/include_resource/dsl'
      require 'chef/cookie_cutter/include_resource/monkey_patches'
      require 'chef/cookie_cutter/include_resource/cookbook_doc'
      require 'chef/cookie_cutter/include_resource/fake_resource'

      Chef::Resource::LWRPBase.send :extend, DSL
      Chef::Resource::LWRPBase.send :prepend, MonkeyPatches::CustomResource
      if defined?(DocumentingLWRPBase)
        DocumentingLWRPBase.send :extend, CookbookDocDSL
        DocumentingLWRPBase.send :extend, FakeResource
      end
      if defined?(KnifeCookbookDoc)
        KnifeCookbookDoc::ReadmeModel.send :prepend, MonkeyPatches::DocumentReadmeModel
        KnifeCookbookDoc::ResourceModel.send :prepend, MonkeyPatches::DocumentResourceModel
      end
    end
  end
end
