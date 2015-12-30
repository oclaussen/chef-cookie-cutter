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
require_relative 'errors'

class Chef
  module CookieCutter
    module IncludeProperties
      module DSL
        def properties_shared?(name)
          exist_state?(:cookie_cutter, :shared_properties, name)
        end

        def share_properties(name, &block)
          fail Errors::SharedPropertiesAlreadyDefined, name if properties_shared? name
          store_state(:cookie_cutter, :shared_properties, name, block)
        end

        def include_properties(name, *args, **kwargs)
          fail Errors::SharedPropertiesNotDefined, name unless properties_shared? name
          block = fetch_state(:cookie_cutter, :shared_properties, name)
          args << kwargs unless kwargs.empty?
          instance_exec(*args, &block)
        end
      end
    end
  end
end
