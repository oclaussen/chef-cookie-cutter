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
require 'chef/cookie_cutter/namespace/namespace'

class Chef
  module CookieCutter
    module Namespace
      module DSL
        def namespace(*args)
          keys = args.map(&:to_s)
          attribute = Namespace.deep_fetch(node.attributes, keys)
          yield attribute if block_given?
        end
      end
    end
  end
end
