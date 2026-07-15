# frozen_string_literal: true

require_relative '../../lib/plugs'

class NestedPlugs
  include Plugs

  plug(:a) do
    plug(:b) do
      plug(:d) do
        4
      end
      2
    end

    plug(:c) do
      3
    end
    1
  end
end

RSpec.describe NestedPlugs do
  describe '.plug(:key)' do
    context 'top level' do
      subject(:plug) { described_class.plugs[:a].first }

      it 'defines plug' do
        expect(plug).to be_an_instance_of(Plugs::Plug)
      end

      it 'defines children' do
        expect(plug.children.first).to have_attributes(key: :b)
        expect(plug.children.last).to have_attributes(key: :c)
      end
    end

    context 'second level' do
      subject(:plug) { described_class.plugs[:b].first }

      it 'defines a child' do
        expect(plug.children.first).to have_attributes(key: :d)
      end
    end
  end

  describe '.[]' do
    describe '.to_a' do
      it 'returns plugs' do
        expect(described_class[:a, :b, :c, :d].to_a).to eq([1, 2, 3, 4])
      end
    end
  end
end
