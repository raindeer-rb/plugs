# frozen_string_literal: true

require_relative '../../lib/plugs'

class DuplicateElements
  include Plugs

  plug(:a) do
    1
  end

  plug(:a) do
    2
  end
end

RSpec.describe DuplicateElements do
  describe '.[]' do
    context 'with a single key' do
      subject { DuplicateElements[:a] }

      it 'returns multiple dependencies' do
        expect(subject).to eq([1, 2])
      end
    end

    context 'with a missing key' do
      subject { DuplicateElements[:c] }

      it 'raises missing key error' do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end
end
