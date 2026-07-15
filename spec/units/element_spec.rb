# frozen_string_literal: true

require_relative '../../lib/plugs'

class Element
  include Plugs

  plug(:a) do
    require_relative '../fixtures/a'
    A
  end
end

RSpec.describe Element do
  subject { Element[:a] }

  describe '.plug' do
    it 'evaluates the block' do
      expect(subject.plugs.first.result).to eq(A)
    end
  end
end
