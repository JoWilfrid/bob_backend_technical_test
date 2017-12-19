# frozen_string_literal: true

require 'level'

RSpec.describe Level do
  let(:data_file) { File.join(APPLICATION_ROOT, 'data/output.json') }
  let(:expectation) { JSON.parse(File.read(data_file)) }

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

    it 'should return a non-nil result' do
      expect(subject.result).not_to be_nil
    end

    it 'should meet the expectations' do
      subject.run

      json_result = JSON.parse(subject.result.to_json)

      expect(json_result).to eq expectation
    end
  end
end
