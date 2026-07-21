# frozen_string_literal: true

require_relative '../../lib/plugs'

class All
  include Plugs

  plug(:a) do
    1
  end

  plug(:b) do
    2
  end
end

RSpec.describe 'All Plugs' do
  describe '.to_a' do
    it 'exports all plugs' do
      expect(All.to_a).to eq([1, 2])
    end
  end
end
