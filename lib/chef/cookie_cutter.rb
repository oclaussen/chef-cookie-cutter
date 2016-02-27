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
  ##
  # Cookie Cutter is a collection of hacks and monkey patches for Chef.
  #
  module CookieCutter
    require 'chef/cookie_cutter/version'

    require 'chef/cookie_cutter/collect_property'
    require 'chef/cookie_cutter/extended_provides'
    require 'chef/cookie_cutter/fancy_property'
    require 'chef/cookie_cutter/include_resource'
    require 'chef/cookie_cutter/run_state'
    require 'chef/cookie_cutter/shared_properties'

    require 'chef/cookie_cutter/autodocs'
    require 'chef/cookie_cutter/spec_matchers'
  end
end
