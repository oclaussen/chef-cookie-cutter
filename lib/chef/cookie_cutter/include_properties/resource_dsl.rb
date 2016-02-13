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
    module IncludeProperties
      module ResourceDSL
        class SharedPropertiesNotDefined < StandardError
          def initialize(name)
            super <<-EOH
A property set with the name #{name} has not been shared.
EOH
          end
        end

        def properties_shared?(name)
          exist_state?(:cookie_cutter, :shared_properties, name)
        end

        def include_properties(name, *args, **kwargs)
          raise SharedPropertiesNotDefined, name unless properties_shared? name
          block = fetch_state(:cookie_cutter, :shared_properties, name)
          args << kwargs unless kwargs.empty?
          instance_exec(*args, &block)
        end
      end
    end
  end
end
