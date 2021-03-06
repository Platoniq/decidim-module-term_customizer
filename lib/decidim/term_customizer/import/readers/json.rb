# frozen_string_literal: true

require "json"

module Decidim
  module TermCustomizer
    module Import
      module Readers
        # Imports any exported JSON file to local objects. It transforms the
        # import data using the parser into the final target objects.
        class JSON < Base
          MIME_TYPE = "application/json"

          def read_rows
            json_string = File.read(file)
            ::JSON.parse(json_string).each_with_index do |row, index|
              yield row.keys, index if index.zero?
              yield row.values, index + 1
            end
          end
        end
      end
    end
  end
end
