# frozen_string_literal: true

##
# The top level Chef class.
#
class Chef
  ##
  # Cookie Cutter is a collection of hacks and monkey patches for Chef.
  #
  module CookieCutter
    require 'chef/cookie_cutter/version'

    require 'chef/cookie_cutter/block_in_file'
    require 'chef/cookie_cutter/collect_property'
    require 'chef/cookie_cutter/fancy_property'
    require 'chef/cookie_cutter/include_resource'
    require 'chef/cookie_cutter/ohai_helpers'
    require 'chef/cookie_cutter/provides_named'
    require 'chef/cookie_cutter/run_state'
    require 'chef/cookie_cutter/service_script'
    require 'chef/cookie_cutter/shared_properties'

    require 'chef/cookie_cutter/autodocs'
    require 'chef/cookie_cutter/spec_matchers'
    require 'chef/cookie_cutter/spec_stubs'
  end
end
