# frozen_string_literal: true

require_relative '../../lib/plugs'

class FlatElements
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

RSpec.describe FlatElements do
  describe '.[]' do
    context 'with a single key' do
      subject { FlatElements[:a] }

      it 'returns single dependency' do
        expect(subject).to eq(A)
      end
    end

    context 'with multiple keys' do
      subject { FlatElements[:a, :b] }

      it 'returns multiple dependencies' do
        expect(subject).to eq([A, B])
      end
    end
  end
end
