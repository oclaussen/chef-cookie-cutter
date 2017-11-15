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
require 'chef/property'
require 'chef/recipe'
require 'chef/resource/lwrp_base'

class Chef
  module CookieCutter
    ##
    # Extends most Chef DSLs to include additional metadata information. This
    # information may be used, for example, to automatically generate
    # documentation for your cookbook.
    #
    # This also includes a rake task to generate a README.md file with the
    # provided metadata.
    #
    module Autodocs
      require 'chef/cookie_cutter/autodocs/property_dsl'
      require 'chef/cookie_cutter/autodocs/recipe_dsl'
      require 'chef/cookie_cutter/autodocs/resource_dsl'
      require 'chef/cookie_cutter/autodocs/shared_properties_dsl'

      ::Chef::Property.send :prepend, PropertyDSL
      ::Chef::Recipe.send :include, RecipeDSL
      ::Chef::Resource::LWRPBase.send :include, ResourceDSL

      if defined?(CookieCutter::SharedProperties)
        CookieCutter::SharedProperties::SharedProperties.send :include, SharedPropertiesDSL
      end
    end
  end
end
