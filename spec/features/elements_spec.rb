# frozen_string_literal: true

require_relative '../../lib/plugs'

class Elements
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

RSpec.describe Elements do
  describe '.[]' do
    context 'with a single key' do
      subject { Elements[:a] }

      it 'returns single dependency' do
        expect(subject).to eq(A)
      end
    end

    context 'with multiple keys' do
      subject { Elements[:a, :b] }

      it 'returns multiple dependencies' do
        expect(subject).to eq([A, B])
      end
    end
  end
end
