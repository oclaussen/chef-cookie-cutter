# encoding: UTF-8

require 'chef/recipe'
require 'chef/resource'
require 'chef/provider'

class Chef
  module CookieCutter
    require_relative 'cookie_cutter/lwrp_include'
    require_relative 'cookie_cutter/namespace'
    require_relative 'cookie_cutter/run_state'
    require_relative 'cookie_cutter/shared_blocks'
    require_relative 'cookie_cutter/fancy_property'
  end
end

Chef::Recipe.send(:include, Chef::CookieCutter::DSL)
Chef::Resource.send(:include, Chef::CookieCutter::DSL)
Chef::Provider.send(:include, Chef::CookieCutter::DSL)
Chef::Resource::LWRPBase.send(:extend, Chef::CookieCutter::ResourceDSL)
# Chef::Provider::LWRPBase.send(:extend, Chef::CookieCutter::ProviderDSL)
