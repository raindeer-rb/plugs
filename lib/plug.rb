# frozen_string_literal: true

module Plugs
  class Plug
    attr_reader :key, :result, :children

    def initialize(key:, eager: true, &block)
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
