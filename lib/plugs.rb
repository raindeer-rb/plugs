# frozen_string_literal: true

require_relative 'plug'

module Plugs
  attr_accessor :plugs

  def self.included(base)
    @plugs = {}
    base.extend(ClassMethods)
  end

  module ClassMethods
    def [](*keys)
      results = plugs.fetch_values(*keys).flatten.map(&:result)

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
