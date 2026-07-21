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

RSpec.describe 'Nested Plugs' do
  describe '.plug(:key)' do
    context 'top level' do
      subject(:plug) { NestedPlugs.plugs[:a].first }

      it 'defines plug' do
        expect(plug).to be_an_instance_of(Plugs::Plug)
      end

      it 'defines children' do
        expect(plug.children.first).to have_attributes(key: :b)
        expect(plug.children.last).to have_attributes(key: :c)
      end
    end

    context 'second level' do
      subject(:plug) { NestedPlugs.plugs[:b].first }

      it 'defines a child' do
        expect(plug.children.first).to have_attributes(key: :d)
      end
    end
  end

  describe '.[]' do
    it 'returns plugs' do
      expect(NestedPlugs[:a, :b, :c, :d].to_a).to eq([1, 2, 4, 3])
    end
  end

  describe '#[]' do
    describe 'a parent plug' do
      subject(:plugs) { NestedPlugs[:a] }

      it 'includes children' do
        expect(plugs[:b].to_a).to eq([2, 4])
        expect(plugs[:b][:d].to_a).to eq([4])
      end

      it 'excludes siblings' do
        expect { plugs[:b][:c] }.to raise_error(KeyError)
      end
    end
  end
end
