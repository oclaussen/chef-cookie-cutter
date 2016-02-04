# encoding: UTF-8
#
# Copyright 2015, Ole Claussen <claussen.ole@gmail.com>
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
      module MarkdownHelper
        def link(text)
          "[#{text}](##{text})"
        end

        def list(items)
          items.map { |item| "* #{item}" }.join "\n"
        end

        def segment_toc(items)
          items = items.map do |item|
            text = item.respond_to?(:name) ? item.name : item.to_s
            return text unless item.respond_to?(:short_description) && !item.short_description.empty?
            "#{link text} - #{item.short_description}"
          end
          list items
        end
      end
    end
  end
end
