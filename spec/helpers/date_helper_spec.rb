# frozen_string_literal: true

require 'helpers/date_helper'

RSpec.describe DateHelper do
  let(:subject_class) do
    class Anything
      include DateHelper
    end
  end

  subject { subject_class.new }

  describe '#parse_date' do
    it 'should return a Date object' do
      expect(subject.parse_date('anything')).to be_an_instance_of Date
    end

    it 'should parse correctly' do
      input = '2017-12-25'

      Date.expects(:new).with(2017, 12, 25)

      subject.parse_date(input)
    end
  end

  describe '#days_difference_between' do
    context 'including all days' do
      it 'should compute correctly' do
        date_1 = Date.new(2017, 1, 1)
        date_2 = Date.new(2017, 1, 5)
        expected = 5

        expect(subject.days_difference_between(date_1, date_2)).to eq expected
      end
    end

    context 'not including all days' do
      it 'should compute correctly' do
        date_1 = Date.new(2017, 1, 1)
        date_2 = Date.new(2017, 1, 5)
        expected = 4

        expect(subject.days_difference_between(date_1, date_2, false)).to eq expected
      end
    end
  end
end
