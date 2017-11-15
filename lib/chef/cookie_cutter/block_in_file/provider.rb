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
# TODO: fix these
# rubocop:disable Performance/RegexpMatch
# rubocop:disable Style/PerlBackrefs
require 'chef/file_content_management/content_base'
require 'chef/file_content_management/tempfile'
require 'chef/mixin/securable'
require 'chef/provider/file'
require 'chef/resource/file'

class Chef
  class Resource
    class BlockInFile < Chef::Resource::File
      resource_name :block_in_file

      property :identifier, Symbol, identity: true, required: true
      property :comment, Proc, required: true
      property :priority, Integer, default: 0
      property :text, [String, nil], desired_state: false
    end
  end

  class Provider
    class BlockInFile < Chef::Provider::File
      provides :block_in_file

      def initialize(new_resource, run_context)
        @content_class = Chef::Provider::BlockInFile::Content
        super
      end

      def load_current_resource
        @current_resource = Chef::Resource::BlockInFile.new(new_resource.name)
        super
      end

      private

      def managing_content?
        return true if new_resource.checksum
        return true if @action != :create_if_missing
        false
      end

      class Content < Chef::FileContentManagement::ContentBase
        def file_for_provider
          return nil if @new_resource.text.nil?
          tempfile = Chef::FileContentManagement::Tempfile.new(@new_resource).tempfile
          tempfile.write(new_lines.join)
          tempfile.close
          tempfile
        end

        private

        def current_lines
          @lines ||= if ::File.exist?(@new_resource.path)
                       ::File.readlines(@new_resource.path)
                     else
                       []
                     end
        end

        def new_lines
          if preceding_in_order? && following_in_order?
            target = current_start_index
            current_lines.slice!(current_start_index, current_end_index - current_start_index + 1)
            beginning = current_lines.slice!(0, target)
          else
            if !current_start_index.nil? && !current_end_index.nil?
              current_lines.slice!(current_start_index, current_end_index - current_start_index + 1)
            end
            beginning = current_lines.slice!(0, new_start_index)
          end
          beginning + [start_marker, new_text, end_marker] + current_lines
        end

        def new_text
          return '' if @new_resource.text.nil?
          if @new_resource.text.end_with?("\n")
            @new_resource.text
          else
            "#{@new_resource.text}\n"
          end
        end

        def start_marker
          marker = ":#{@new_resource.priority}:start:#{@new_resource.identifier}:"
          marker = @new_resource.comment.call(marker)
          "#{marker}\n"
        end

        def end_marker
          marker = ":#{@new_resource.priority}:end:#{@new_resource.identifier}:"
          marker = @new_resource.comment.call(marker)
          "#{marker}\n"
        end

        def current_start_index
          current_lines.find_index do |line|
            line =~ /:(\d+):start:#{@new_resource.identifier}:/
          end
        end

        def current_end_index
          current_lines.find_index do |line|
            line =~ /:(\d+):end:#{@new_resource.identifier}:/
          end
        end

        def new_start_index
          current_lines.find_index do |line|
            next false if line =~ /:(\d+):start:#{@new_resource.identifier}:/
            next false unless line =~ /:(\d+):start:/
            $1.to_i >= @new_resource.priority
          end || current_lines.length
        end

        def preceding_in_order?
          return false if current_start_index.nil?
          preceding_line = current_lines[current_start_index - 1]
          return true if preceding_line.nil?
          return true unless preceding_line =~ /:(\d+):end:/
          $1.to_i <= @new_resource.priority
        end

        def following_in_order?
          return false if current_end_index.nil?
          following_line = current_lines[current_end_index + 1]
          return true if following_line.nil?
          return true unless following_line =~ /:(\d+):start:/
          $1.to_i >= @new_resource.priority
        end
      end
    end
  end
end
