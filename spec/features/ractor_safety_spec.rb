# frozen_string_literal: true

require_relative '../../lib/plugs'

class RactorSafePlugs
  include Plugs

  plug(:eager) do
    'eager-result'
  end

  plug(:lazy) do
    lazy { 'lazy-result' }
  end
end

RSpec.describe '.make_shareable!' do
  before(:all) { RactorSafePlugs.make_shareable! }

  it 'freezes the plug tree' do
    expect(RactorSafePlugs.plugs).to be_frozen
  end

  it 'still resolves an eager plug normally' do
    expect(RactorSafePlugs[:eager].to_a).to eq(['eager-result'])
  end

  it 'still resolves a lazy plug normally' do
    expect(RactorSafePlugs[:lazy].to_a).to eq(['lazy-result'])
  end

  it 'is callable from a worker Ractor for an eager plug' do
    ractor = Ractor.new { RactorSafePlugs[:eager].to_a }
    expect(ractor.take).to eq(['eager-result'])
  end

  it 'is callable from a worker Ractor for an already-warmed lazy plug' do
    ractor = Ractor.new { RactorSafePlugs[:lazy].to_a }
    expect(ractor.take).to eq(['lazy-result'])
  end
end
