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

require 'chef/cookie_cutter/autodocs/doc_runner'
require 'erubis'
require 'rake'
require 'rake/tasklib'

class Chef
  module CookieCutter
    module Autodocs
      class RakeTask < ::Rake::TaskLib
        attr_accessor :name, :cookbook_path, :output_file, :template_file

        def initialize(name = :autodoc)
          @name = name
          @cookbook_path = '.'
          @output_file = 'README.md'
          @template_file = Pathname.new("#{File.dirname(__FILE__)}/README.md.erb").realpath

          desc 'Generate cookbook documentation' unless ::Rake.application.last_comment
          task(name) do
            template = File.read(@template_file)
            runner = Autodocs::DocRunner.new(@cookbook_path)
            result = Erubis::Eruby.new(template).result(runner.get_binding)
            File.open(@output_file, 'wb') do |file|
              file.write result
            end
          end
        end
      end
    end
  end
end
