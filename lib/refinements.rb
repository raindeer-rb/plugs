module Plugs
  module Refinements
    refine Hash do
      def slice!(*keys)
        keys.zip(self.fetch_values(*keys)).to_h
      end
    end
  end
end
