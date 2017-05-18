# encoding: UTF-8
# frozen_string_literal: true

#
# Copyright 2017, Ole Claussen <claussen.ole@gmail.com>
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

require 'chef/resource/lwrp_base'
require 'chef/cookie_cutter/collect_property'

describe 'Chef::Resource.property' do
  let(:resource_class) do
    Class.new(Chef::Resource::LWRPBase) do
      resource_name 'test_resource_class'
    end
  end

  let(:resource) do
    resource_class.new 'test_resource'
  end

  context 'with collect: true' do
    before do
      resource_class.property :test, collect: true
    end

    context 'and no calls' do
      it 'has empty collect properties' do
        expect(resource.test).to eq []
      end
    end

    context 'and two calls' do
      before do
        resource.test 'value 1'
        resource.test 'value 2'
      end

      it 'contains both values' do
        expect(resource.test).to contain_exactly 'value 1', 'value 2'
      end
    end
  end
end
