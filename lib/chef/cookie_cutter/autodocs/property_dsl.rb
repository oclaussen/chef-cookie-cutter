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
      module PropertyDSL
        def description
          desc = ''
          desc = options[:description] if options.key?(:description)
          desc += '.' unless desc.empty? || desc.end_with?('.')
          desc += " Must be a `#{options[:coerce_resource]}` resource or a block." if options.key?(:coerce_resource)
          desc += ' This attribute can be specified multiple times.' if options[:collect]
          if options.key?(:default)
            default = "`#{options[:default]}`"
            default = options[:default].description if options[:default].is_a?(Chef::DelayedEvaluator)
            desc += " Defaults to #{default}."
          end
          desc
        end

        def validation_options
          super.delete_if do |k, _|
            [:description, :default_description].include? k
          end
        end
      end
    end
  end
end
