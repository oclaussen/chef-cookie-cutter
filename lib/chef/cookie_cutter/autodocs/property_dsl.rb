# encoding: UTF-8
# frozen_string_literal: true
#
# Copyright 2016, Ole Claussen <claussen.ole@gmail.com>
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
      # Extensions to the Chef property DSL.
      #
      module PropertyDSL
        ##
        # Get the description set for property. A description on the resource
        # can be set initially by adding the new `:description` validation
        # option. Will automatically add a description for  `:collect` and
        # `:coerce_resource` validation options set on the property.
        #
        # @return [String] the description for the resource
        #
        def description
          desc = ''
          desc = options[:description] if options.key?(:description)
          desc += '.' unless desc.empty? || desc.end_with?('.')
          desc += " Must be a `#{options[:coerce_resource]}` resource or a block." if options.key?(:coerce_resource)
          desc += ' This attribute can be specified multiple times.' if options[:collect]
          desc
        end

        ##
        # Get a description of the default value of the property. Will describe
        # whether the property is required, name attribute or has a default
        # value.
        #
        # @return [String] a description of the default value
        #
        def describe_default
          if required?
            '*Required*'
          elsif name_property?
            'The name of the resource'
          elsif has_default?
            if options[:default].is_a?(Chef::DelayedEvaluator)
              options[:default].description
            else
              "`#{options[:default]}`"
            end
          else
            ''
          end
        end

        ##
        # If the coercion of the property allows for multiple or named arguments
        # (e.g. via the `fancy_property` module), get a textual description of
        # these arguments
        #
        # @return [String] a description of the property coercion arguments
        #
        def describe_arguments
          return '' unless respond_to?(:allow_kwargs?) && allow_kwargs?
          method = if options.key?(:coerce_class)
                     if options[:coerce_class].is_a?(Proc)
                       target = Class.new
                       target.class_eval(&options[:coerce_class])
                     else
                       target = options[:coerce_class]
                     end
                     target.instance_method(:initialize)
                   elsif options.key?(:coerce)
                     options[:coerce]
                   end
          params = method.parameters.map do |type, name|
            # FIXME: does not consider required key arguments.
            # FIXME: displays default values only as ?
            case type
            when :req
              name.to_s
            when :opt
              "#{name} = ?"
            when :rest
              "*#{name}"
            when :key
              "#{name}: ?"
            when :keyrest
              "**#{name}"
            end
          end
          "`#{params.join(', ')}`"
        end

        # @!visibility private
        def validation_options
          super.delete_if do |k, _|
            [:description, :default_description].include? k
          end
        end
      end
    end
  end
end
