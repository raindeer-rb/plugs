# frozen_string_literal: true

require_relative '../../lib/plugs'

class A
  include Plugs

  plug(:a) do
    1
  end
end

class B
  include Plugs

  plug(:b) do
    2
  end
end

RSpec.describe 'Combined Plugs' do
  describe 'A[:a] + B[:b]' do
    subject { A[:a] + B[:b] }

    it 'combines plugs' do
      expect(subject.to_a).to eq([1, 2])
    end
  end
end
