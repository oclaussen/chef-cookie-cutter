# frozen_string_literal: true

require 'chef/resource/lwrp_base'

class Chef
  module CookieCutter
    ##
    # Allows custom resources to mixin other resources.
    #
    # @example File my_cookbook/resources/mixins/common.rb
    #   attribute :foo, kind_of: String, default: 'foo'
    #
    # @example File my_other_cookbook/resources/test.rb
    #   include_resource 'mixin/common', cookbook: 'my_cookbook'
    #
    #   attribute :bar, kind_of: String, default: 'bar'
    #
    # @example File my_other_cookbook/recipes/test.rb
    #   my_cookbook_test 'test' do
    #     foo 'Hello'
    #     bar 'World'
    #   end
    #
    module IncludeResource
      require 'chef/cookie_cutter/include_resource/resource_dsl'
      require 'chef/cookie_cutter/include_resource/resource'

      Chef::Resource::LWRPBase.send :extend, ResourceDSL
      Chef::Resource::LWRPBase.send :prepend, CustomResource
    end
  end
end
