# frozen_string_literal: true

require 'formatters/rental_formatter'

RSpec.describe RentalFormatter do
  let(:rental) do
    OpenStruct.new(
      id: 1,
      actions: {}
    )
  end

  describe '#initialize' do
    it 'should init without params' do
      expect(RentalFormatter.new).not_to be_nil
    end
  end

  describe 'class methods' do
    describe '#format' do
      it 'should have right keys' do
        result = subject.class.format(rental)

        expect(result).to have_key :id
        expect(result).to have_key :actions
      end
    end
  end

  describe 'instance methods' do
    describe '#format' do
      it 'should delegate to class method' do
        RentalFormatter.expects(:format).with(rental).once

        subject.format(rental)
      end
    end
  end
end
