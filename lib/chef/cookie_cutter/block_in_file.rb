# frozen_string_literal: true

require 'chef/recipe'
require 'chef/resource'

class Chef
  module CookieCutter
    module RunState
      require 'chef/cookie_cutter/block_in_file/provider.rb'
    end
  end
end
