# frozen_string_literal: true

require_relative '../../lib/plugs'

class LazyPlugs
  include Plugs

  class << self
    attr_accessor :a_call_count, :b_call_count
  end

  self.a_call_count = 0
  self.b_call_count = 0

  plug(:lazy_a) do
    plug(:eager_c) do
      'C'
    end

    lazy do
      self.a_call_count += 1
      'A'
    end
  end

  plug(:lazy_b) do
    lazy do
      self.b_call_count += 1
      'B'
    end
  end
end

RSpec.describe 'Lazy Plugs' do
  describe '.plug(:key)' do
    it 'defines lazy plugs' do
      expect(LazyPlugs.a_call_count).to eq(0)
    end

    it 'defines eager plugs' do
      expect(LazyPlugs.plugs[:lazy_a].first.children.first).to have_attributes(key: :eager_c)
    end
  end

  describe '.[]' do
    it 'does not evaluate lazy blocks' do
      selection = LazyPlugs[:lazy_a]

      expect(LazyPlugs.a_call_count).to eq(0)
      expect(LazyPlugs.b_call_count).to eq(0)
    end
  end

  describe '#to_a' do
    it 'evaluates child lazy blocks once' do
      selection = LazyPlugs[:lazy_a]

      3.times { selection.to_a }

      expect(LazyPlugs.a_call_count).to eq(1)
      expect(LazyPlugs.b_call_count).to eq(0)
    end
  end
end
