# frozen_string_literal: true

require 'chef/resource'
require 'chef/resource_builder'

class Chef
  module CookieCutter
    ##
    # Adds a `:named` option to the `Resource.provides` DSL method. It can be
    # passed either a String, Symbol or a Regexp. If given, the resource will
    # provide a DSL name, if the name of the resource matches that argument.
    #
    # @example File my_cookbook/resources/test.rb
    #   provides :fancy_resource_name, named: 'foo'
    #
    # @example File my_cookbook/recipes/test.rb
    #   fancy_resource_name 'foo' do
    #     ...
    #   end
    #
    module ProvidesNamed
      require 'chef/cookie_cutter/provides_named/resource'
      require 'chef/cookie_cutter/provides_named/resource_builder'

      ::Chef::Resource.send :prepend, CustomResource
      ::Chef::ResourceBuilder.send :prepend, ResourceBuilder
    end
  end
end
