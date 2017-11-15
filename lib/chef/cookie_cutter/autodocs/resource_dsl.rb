# frozen_string_literal: true

#
# Copyright 2017, Ole Claussen <claussen.ole@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef
  module CookieCutter
    module Autodocs
      ##
      # Extensions to the Chef resource DSL
      #
      module ResourceDSL
        ##
        # Describes an action on the resource
        #
        class Action
          attr_reader :name
          attr_accessor :description
          attr_accessor :internal

          def initialize(name, description = '', internal: false)
            @name = name
            @description = description
            @internal = internal
          end
        end

        ##
        # Extensions of the Chef resource class DSL
        #
        module ClassMethods
          ##
          # Get the name of the resource
          #
          # @return [String] the resource name
          #
          def name
            resource_name
          end

          ##
          # Get or set a description for the resource.
          #
          # @param text [String] if given, will set the description of the resource to this text
          # @return [String] the description of the resource
          #
          def description(text = nil)
            @description = text unless text.nil?
            return @description unless @description.nil?
            ''
          end

          ##
          # Get a short description for the resource. The short description is
          # simply the first full sentence of the normal #description.
          #
          # @return [String] the first sentence of the description
          #
          def short_description
            match = Regexp.new('^(.*?\.(\z|\s))', Regexp::MULTILINE).match(description)
            return description if match.nil?
            match[1].tr("\n", ' ').strip
          end

          ##
          # Get the descriptions for actions on the resource.
          #
          # @return [Hash<Symbol, Action>] the description set for the actions
          #
          def action_descriptions
            @action_descriptions ||= {
              # Ignore the :nothing action by default
              nothing: Action.new(:nothing, internal: true)
            }
          end

          ##
          # Describe an action on the resource.
          #
          # @param name [Symbol] the action name
          # @yield [Action] the action description
          #
          def describe_action(name, &blk)
            action_descriptions[name] ||= Action.new(name)
            action_descriptions[name].instance_eval(&blk) if block_given?
          end
        end

        # @!visibility private
        module ClassMethodsMP
          def action(name, description = nil, internal: nil, &blk)
            super(name, &blk)
            describe_action(name) do |a|
              a.description = description unless description.nil?
              a.internal = internal unless internal.nil?
            end
          end

          def lazy(description = 'a lazy value', &blk)
            lazy_proc = super(&blk)
            lazy_proc.instance_variable_set :@description, description
            lazy_proc.define_singleton_method :description do
              @description
            end
            lazy_proc
          end
        end

        # @!visibility private
        def self.included(base)
          class << base
            include ClassMethods
            prepend ClassMethodsMP
          end
        end
      end
    end
  end
end
