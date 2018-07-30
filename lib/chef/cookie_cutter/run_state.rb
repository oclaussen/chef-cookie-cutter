# frozen_string_literal: true

require 'chef/recipe'
require 'chef/resource'

class Chef
  module CookieCutter
    ##
    # Provides methods to easily store values in the Chef run state, so they can
    # be used across recipes.
    #
    # @example File my_cookbook/recipes/test.rb
    #   store_state(:my_cookbook, :test, :foo, 'bar')
    #
    #   file 'testfile' do
    #     content fetch_state(:my_cookbook, :test, :foo)
    #   end
    #
    module RunState
      require 'chef/cookie_cutter/run_state/recipe_dsl'

      ::Chef::Recipe.send :include, RecipeDSL
      ::Chef::Resource.send :include, RecipeDSL
    end
  end
end
