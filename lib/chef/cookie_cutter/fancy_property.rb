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
require 'chef/property'

class Chef
  # Define Chef::Property in case we are pre 12.5 and it doesn't exist yet.
  class Property
  end

  module CookieCutter
    module FancyPropertyModule
      require_relative 'fancy_property/property'
      require_relative 'fancy_property/cookbook_doc'

      if defined?(KnifeCookbookDoc)
        KnifeCookbookDoc::ResourceModel.send :prepend, MonkeyPatches::DocumentResourceModel
      end
    end
  end
end
