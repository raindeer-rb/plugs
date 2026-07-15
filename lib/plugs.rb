# frozen_string_literal: true

require_relative 'plug'

module Plugs
  attr_accessor :plugs

  def [](*keys)
    @plugs.values_at(*keys)
  end

  def self.included(base)
    @plugs = {}
    base.extend(ClassMethods)
  end

  module ClassMethods
    def [](*keys)
      results = plugs.values_at(*keys).flatten.map(&:result)

      return results.first if results.count <= 1

      results
    end

    def plug(key, &block)
      plug = Plug.new(key:, &block)

      plugs[key] ||= []
      plugs[key] << plug

      plug.result
    end

    def plugs
      @plugs ||= {}
      @plugs
    end
  end
end
