# frozen_string_literal: true

require_relative '../../lib/plugs'

class NestedElements
  include Plugs

  plug(:a) do
    plug(:b) do
      2
    end
  end
end

RSpec.describe NestedElements do
  describe '.[]' do
    context 'with parent key' do
      subject { NestedElements[:a] }

      it 'returns parent dependency' do
        expect(subject).to be([])
      end
    end
  end
end
