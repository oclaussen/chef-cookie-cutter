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
    module SpecStubs
      ##
      # Changes to the Chef Resource DSL
      #
      module ResourceDSL
        def only_if(command = nil, opts = {}, &blk)
          autostub_command(command, opts)
          super
        end

        def not_if(command = nil, opts = {}, &blk)
          autostub_command(command, opts)
          super
        end

        def autostub_command(command, opts)
          return unless defined?(ChefSpec)
          return if command.nil?
          return unless opts.key?(:stub_with)
          ChefSpec::Macros.stub_command(command).and_return(opts[:stub_with])
        end
      end
    end
  end
end
