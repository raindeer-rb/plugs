# frozen_string_literal: true

module Plugs
  class Plug
    attr_reader :key, :result

    def initialize(key:, eager: false, &block)
      @key = key
      @proc = block
      @result = eager ? block.call : nil
    end

    def result
      @result ||= @proc.call
    end
  end
end
