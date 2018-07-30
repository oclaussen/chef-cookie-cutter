# frozen_string_literal: true

require 'chef/property'

class Chef
  module CookieCutter
    ##
    # Adds new validation parameter `:collect` to properties. If set to `true`,
    # the property can be called multiple times on a resource, and all values
    # will be collected in an array.
    #
    # @example File my_cookbook/resources/test.rb
    #   property :foo, collect: true
    #
    # @example File my_cookbook/recipes/test.rb
    #   my_cookbook_test 'test' do
    #     foo 'Hello'
    #     foo 'World'
    #   end
    #
    module CollectProperty
      require 'chef/cookie_cutter/collect_property/property_dsl'
      ::Chef::Property.send :prepend, PropertyDSL
    end
  end
end
