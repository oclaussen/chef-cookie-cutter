# frozen_string_literal: true

require 'chef/node'
require 'chef/recipe'

class Chef
  module CookieCutter
    module OhaiHelpers
      require 'chef/cookie_cutter/ohai_helpers/node_dsl'

      ::Chef::Node.send :include, NodeDSL
      ::Chef::Recipe.send :include, NodeDSL
    end
  end
end
