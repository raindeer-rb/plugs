# frozen_string_literal: true

require_relative '../../lib/plugs'

class FlatPlugs
  include Plugs

  plug(:a) do
    require_relative '../fixtures/a'
    A
  end

  plug(:b) do
    require_relative '../fixtures/b'
    B
  end
end

RSpec.describe FlatPlugs do
  describe '.[]' do
    context 'with a single key' do
      subject { FlatPlugs[:a].to_a }

      it 'returns single dependency' do
        expect(subject).to eq([A])
      end
    end

    context 'with multiple keys' do
      subject { FlatPlugs[:a, :b].to_a }

      it 'returns multiple dependencies' do
        expect(subject).to eq([A, B])
      end
    end
  end
end
