# frozen_string_literal: true

module Plugs
  class Plug
    attr_reader :key, :children

    def initialize(key:, &block)
      @key = key
      @proc = block
      @result = nil
      @children = []
    end

    def result
      @result ||= @proc.call
    end
  end
end
