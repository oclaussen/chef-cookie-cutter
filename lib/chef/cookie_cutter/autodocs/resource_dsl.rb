# encoding: UTF-8
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
    module Autodocs
      module ResourceDSL
        module ClassMethods
          def name
            resource_name
          end

          def description(text = nil)
            @description = text unless text.nil?
            return @description unless @description.nil?
            ''
          end

          def short_description
            match = Regexp.new('^(.*?\.(\z|\s))', Regexp::MULTILINE).match(description)
            return description if match.nil?
            match[1].tr("\n", ' ').strip
          end

          def action_descriptions
            @action_descriptions ||= {}
          end
        end

        module ClassMethodsMP
          def action(name, description = '', &blk)
            super(name, &blk)
            action_descriptions[name] = description
          end

          def lazy(description = 'a lazy value', &blk)
            lazy_proc = super(&blk)
            lazy_proc.instance_variable_set :@description, description
            lazy_proc.define_singleton_method :description do
              @description
            end
            lazy_proc
          end
        end

        def self.included(base)
          class << base
            include ClassMethods
            prepend ClassMethodsMP
          end
        end
      end
    end
  end
end
