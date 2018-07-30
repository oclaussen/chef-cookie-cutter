# frozen_string_literal: true

require 'chef/resource'

class Chef
  module CookieCutter
    ##
    # Extends `not_if` and `only_if` clauses on resources, so they can
    # automatically stub shell commands for ChefSpec.
    #
    # @example File my_cookbook/recipes/test.rb
    #   file '/some/file' do
    #     action :create
    #     content 'Hello World!'
    #     only_if "cat /some/file | grep -q Hello", stub_with: 0
    #   end
    #
    module SpecStubs
      require 'chef/cookie_cutter/spec_stubs/resource_dsl'

      ::Chef::Resource.send :prepend, SpecStubs::ResourceDSL
    end
  end
end
