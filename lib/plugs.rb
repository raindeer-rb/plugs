# frozen_string_literal: true

require_relative 'plug'
require_relative 'refinements'

module Plugs
  using Refinements

  attr_reader :plugs

  class DuplicateKeyError < StandardError; end

  def initialize(plugs:, keys:)
    @plugs = plugs
    @keys = keys
  end

  def [](*keys)
    new(plugs: plugs.slice!(*keys))
  end

  def to_a
    plugs.values.flatten.map(&:result)
  end

  def to_h
    plugs.values.each_with_object({}) do |values, hash|
      values.each do |plug|
        hash[plug.key] ||= []
        hash[plug.key] << plug.result
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    using Refinements

    def plug(key, &block)
      plug = Plug.new(key:, &block)

      plugs[key] ||= []
      plugs[key] << plug
      plug_stack << plug

      plug.result

      plug_stack.pop
      plug_stack.last.children << plug if plug_stack.last

      nil
    end

    def [](*keys)
      new(plugs: plugs.slice!(*keys), keys:)
    end

    def plugs
      @plugs ||= {}
      @plugs
    end

    def plug_stack
      @plug_stack ||= []
      @plug_stack
    end
  end
end
