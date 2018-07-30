# frozen_string_literal: true

require 'chef/property'

class Chef
  module CookieCutter
    ##
    # Extends Chef properties with additional features:
    #
    # * Allows passing `*args`, `**kwargs` and `&block` arguments to properties.
    # Since only a single value can be assigned to an attribute, this will fail
    # if no coercion is provided that handles the given arguments properly. This
    # is option is automatically enabled when a `:coerce` or `:coerce_class`
    # block with higher arity is given. It can be enforced by passing the
    # `:allow_kwargs` parameter.
    # * Adds new validation parameter `:coerce_class`, which takes a class name.
    # The arguments given to the property will be passed to the constructor of
    # the given class, and the value will be set to the resulting instance.
    # * Adds new validation parameter `:coerce_resource`, which takes a resource
    # identifier. The property will then take a name and block. A new resource
    # will be built based on these, and assigned to the property value.
    # * A `:coerce` parameter can be defined in addition to either
    # `:coerce_class` or `:coerce_resource`. It will be called *after* the
    # `:coerce_class` or `:coerce_resource` block and the object or resource
    # instance is passed to the `:coerce` block.
    #
    # @example File my_cookbook/resources/test.rb
    #   class MySampleValueClass
    #     def initialize(foo, bar: false)
    #       @foo = foo
    #     end
    #   end
    #
    #   property :foo, coerce_class: MySampleValueClass
    #
    # @example File my_cookbook/recipes/test.rb
    #   my_cookbook_test 'test' do
    #     foo 'World', true
    #   end
    #
    module FancyProperty
      require 'chef/cookie_cutter/fancy_property/property_dsl'

      ::Chef::Property.send :prepend, PropertyDSL
    end
  end
end
