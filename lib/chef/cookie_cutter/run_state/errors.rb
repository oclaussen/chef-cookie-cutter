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

class Chef
  module CookieCutter
    module RunState
      module Errors
        class RunStateDoesNotExistError < StandardError
          def initialize(keys, key)
            hash = keys.map { |k| "['#{k}']" }
            super <<-EOH
The run_state does not contain an element at run_state#{hash.join}.
Specifically, #{key} is not defined.
EOH
          end
        end
      end
    end
  end
end