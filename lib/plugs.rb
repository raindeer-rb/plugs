# frozen_string_literal: true

require_relative 'lazy'
require_relative 'plug'
require_relative 'sub_selector'

module Plugs
  attr_reader :plugs

  def initialize(plugs:, keys:)
    @plugs = plugs
    @keys = keys
  end

  def [](*keys)
    self.class.new(plugs: SubSelector.sub_select(plugs:, keys:), keys:)
  end

  def +(new_plugs)
    @plugs.merge!(new_plugs.plugs) { |_key, a_values, b_values| [*a_values, *b_values] }

    self
  end

  def to_a
    plugs.values.flatten.map(&:result).map { |value| Lazy.unwrap(value) }
  end

  def to_h
    plugs.values.each_with_object({}) do |values, hash|
      values.each do |plug|
        hash[plug.key] ||= []
        hash[plug.key] << Lazy.unwrap(plug.result)
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
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

    def lazy(&block)
      Lazy.new(&block)
    end

    def [](*keys)
      new(plugs: SubSelector.sub_select(plugs:, keys:), keys:)
    end

    def to_a
      plugs.values.flatten.map(&:result).map { |value| Lazy.unwrap(value) }
    end

    def plugs
      @plugs ||= {}
      @plugs
    end

    # Makes this class's plug tree shareable across Ractors, so a worker Ractor can
    # read plugs via SomeClass[...] / SomeClass.plugs. Call once boot is complete
    # (every plug: block for this class has already been declared) and before
    # spawning any worker Ractors -- the tree is read-only from that point on, same
    # as any other frozen/shareable object.
    #
    # Raises Ractor::IsolationError if any plug's block closes over unshareable
    # state (e.g. a live object stored in a local variable) -- plug blocks must
    # only reference Ractor-shareable values (classes, frozen literals, etc.) for
    # this to succeed.
    def make_shareable!
      warm_lazy_caches!
      Ractor.make_shareable(plugs)
    end

    def plug_stack
      @plug_stack ||= []
      @plug_stack
    end

    private

    # Lazy#call is lazily memoized (computed on first call, not at declaration time)
    # -- calling it for the first time *after* freezing would raise FrozenError
    # trying to cache its result. Resolve every plug's result now, while everything's
    # still mutable, so any Lazy it holds already has its value cached by the time
    # Ractor.make_shareable freezes it.
    def warm_lazy_caches!
      plugs.values.flatten.each { |plug| Lazy.unwrap(plug.result) }
    end
  end
end
