# frozen_string_literal: true

require 'chef/resource'

class Chef
  module CookieCutter
    ##
    # Custom resources will automatically generate matchers for ChefSpec using
    # their `resource_name` and all actions. Custom `provide` declarations are
    # not considered for matchers.
    #
    # @example File my_cookbook/resources/test.rb
    #   resource_name :test
    #
    #   allowed_actions [:create, :delete]
    #
    # @example File my_cookbook
    #   expect(chef_run).to create_test('foo')
    #   expect(chef_run).to delete_test('bar')
    #
    module SpecMatchers
      require 'chef/cookie_cutter/spec_matchers/monkey_patches'

      ::Chef::Resource::LWRPBase.send :prepend, MonkeyPatches::CustomResource
    end
  end
end
