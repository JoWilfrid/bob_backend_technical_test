# frozen_string_literal: true

require 'helpers/numeric_helper'

RSpec.describe NumericHelper do
  let(:subject_class) do
    class Anything
      include NumericHelper
    end
  end

  subject { subject_class.new }

  describe '#integer_unless_float' do
    context 'integer' do
      it 'should return an integer' do
        input = 42
        result = subject.integer_unless_float(input)

        expect(result.to_i).to eq input
      end
    end

    context 'float' do
      it 'should return a float' do
        input = 42.5
        result = subject.integer_unless_float(input)

        expect(result.to_i).not_to eq input
        expect(result.to_f).to eq input
      end
    end
  end
end
