# frozen_string_literal: true

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

        def table(headers, items)
          header = '|' + headers.join('|') + '|'
          line = '|' + headers.map { |h| '-' * h.size }.join('|') + '|'
          content = items.map { |parts| '|' + parts.join('|') + '|' }
          ([header, line] + content).join "\n"
        end

        def segment_toc(items)
          items = items.map do |item|
            text = item.respond_to?(:name) ? item.name : item.to_s
            next text unless item.respond_to?(:short_description) && !item.short_description.empty?
            "#{link text} - #{item.short_description}"
          end
          list items
        end
      end
    end
  end
end
