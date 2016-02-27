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
    module CollectProperty
      # @!visibility private
      module PropertyDSL
        def get(resource)
          if instance_variable_name && collect? && !is_set?(resource)
            []
          else
            super
          end
        end

        def set_value(resource, value)
          if instance_variable_name && collect?
            resource.instance_variable_set(instance_variable_name, []) unless is_set?(resource)
            get_value(resource) << value
          else
            super
          end
        end

        def collect?
          options[:collect]
        end

        def validation_options
          super.delete_if { |k, _| [:collect].include?(k) }
        end
      end
    end
  end
end
