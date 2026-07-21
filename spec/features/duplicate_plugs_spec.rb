# frozen_string_literal: true

require_relative '../../lib/plugs'

class DuplicatePlugs
  include Plugs

  plug(:a) do
    1
  end

  plug(:a) do
    2
  end
end

RSpec.describe DuplicatePlugs do
  describe '.[]' do
    context 'with a single key' do
      subject { DuplicatePlugs[:a] }

      describe '.to_a' do
        it 'returns array of plugs' do
          expect(subject.to_a).to eq([1, 2])
        end
      end

      describe '.to_h' do
        it 'returns hash of plugs' do
          expect(subject.to_h).to eq(a: [1, 2])
        end
      end
    end

    context 'with a missing key' do
      subject { DuplicatePlugs[:c] }

      it 'raises missing key error' do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end
end
