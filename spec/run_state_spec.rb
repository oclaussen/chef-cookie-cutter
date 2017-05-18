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

require 'chef/event_dispatch/dispatcher'
require 'chef/cookbook/cookbook_collection'
require 'chef/node'
require 'chef/recipe'
require 'chef/run_context'
require 'chef/cookie_cutter/run_state'

describe 'Chef::Recipe' do
  let(:run_context) do
    events = Chef::EventDispatch::Dispatcher.new
    cookbook_collection = Chef::CookbookCollection.new
    node = Chef::Node.new
    Chef::RunContext.new(node, cookbook_collection, events)
  end

  let(:recipe) do
    Chef::Recipe.new('test_cookbook', 'test_recipe', run_context)
  end

  context 'with no stored states' do
    it 'can not find any state' do
      expect(recipe.exist_state?(:foo, :bar)).to be false
      expect { recipe.fetch_state(:foo, :bar) }.to raise_error Chef::CookieCutter::RunState::RunStateDoesNotExistError
    end
  end

  context 'with stored state /:foo/:bar' do
    before do
      recipe.store_state(:foo, :bar, :my_fancy_value)
    end

    it 'can find the state' do
      expect(recipe.fetch_state(:foo, :bar)).to eq :my_fancy_value
    end
  end
end
