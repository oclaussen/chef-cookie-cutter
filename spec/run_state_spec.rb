# frozen_string_literal: true

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
