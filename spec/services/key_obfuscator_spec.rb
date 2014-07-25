require 'rails_helper'

RSpec.describe KeyObfuscator, type: :service do
  subject do
    KeyObfuscator.new \
      secret: 'very.secret.such.confidential.wow.lol.biz.info'
  end

  describe '#obfuscate' do
    it 'returns an obfuscated representation of the input' do
      expect(subject.obfuscate 1).to eq('64T3CDSN6CTKEDHM')
    end
  end

  describe '#unobfuscate' do
    it 'returns the input unobfuscated' do
      expect(subject.unobfuscate '64T3CDSN6CTKEDHM').to eq(1)
    end
  end
end