# frozen_string_literal: true

require_relative 'refinements'

module Plugs
  module SubSelector
    using Refinements

    module_function

    def sub_select(plugs:, keys:)
      selection = {}

      plugs.slice!(*keys).each_value do |parent_plugs|
        parent_plugs.each do |parent_plug|
          selection[parent_plug.key] ||= []
          selection[parent_plug.key] << parent_plug unless selection[parent_plug.key].include?(parent_plug)

          children(parent_plug:).each do |child_plug|
            selection[child_plug.key] ||= []
            selection[child_plug.key] << child_plug unless selection[child_plug.key].include?(child_plug)
          end
        end
      end

      selection
    end

    def children(parent_plug:)
      children = []

      parent_plug.children.each do |child_plug|
        children << child_plug
        children = [*children, *children(parent_plug: child_plug)]
      end

      children
    end
  end
end
