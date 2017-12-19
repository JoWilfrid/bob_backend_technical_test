# frozen_string_literal: true

require 'level'

RSpec.describe Level do
  describe '#initialize' do
    it 'should init without params' do
      expect(Level.new).not_to be_nil
    end
  end

  describe '#run' do
    it 'should have a method run' do
      expect { subject.run }.not_to raise_error NoMethodError
    end
  end

  describe '#result' do
    it 'should have a method result' do
      expect { subject.result }.not_to raise_error NoMethodError
    end
  end
end
