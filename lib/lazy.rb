# frozen_string_literal: true

module Plugs
  class Lazy
    def self.unwrap(value)
      value.is_a?(self) ? value.call : value
    end

    def initialize(&block)
      @proc = block
    end

    def call
      return @call if defined?(@call)

      @call = @proc.call
    end
  end
end
