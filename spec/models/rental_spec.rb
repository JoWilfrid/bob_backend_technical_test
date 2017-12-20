# frozen_string_literal: true

require 'models/rental'

RSpec.describe Rental do
  describe '#initialize' do
    it 'should init without params' do
      expect(Rental.new).not_to be_nil
    end

    it 'should not set any attributes if not declared' do
      expect { Rental.new(car: :bar) }.to raise_error NoMethodError
    end

    it 'should set attributes if declared' do
      object = Rental.new(
        id: 1,
        distance: 2,
        deductible_reduction: 3
      )

      expect(object.instance_variable_get(:@id)).to eq 1
      expect(object.instance_variable_get(:@distance)).to eq 2
      expect(object.instance_variable_get(:@deductible_reduction)).to eq 3
    end
  end

  describe 'setters' do
    %i[start_date end_date].each do |date_setter|
      describe "##{date_setter}=" do
        it 'should set the date' do
          date = Date.today

          subject.send("#{date_setter}=", date)

          expect(subject.instance_variable_get(:"@#{date_setter}")).to eq date
        end

        it 'should convert in date object if not' do
          date = Date.today
          date_string = date.strftime('%Y-%m-%d') # rubocop:disable Style/FormatStringToken

          subject.send("#{date_setter}=", date_string)

          expect(subject.instance_variable_get(:"@#{date_setter}")).to be_an_instance_of Date
          expect(subject.instance_variable_get(:"@#{date_setter}")).to eq date
        end
      end
    end

    describe '#car=' do
      it 'should set the car' do
        subject.car = {}

        expect(subject.car).not_to be_nil
      end

      it 'should instanciate a car' do
        Car.expects(:new).once

        subject.car = { anything: :fun }
      end

      it 'should be a car' do
        subject.car = {}

        expect(subject.car).to be_an_instance_of Car
      end
    end
  end

  describe '#day_duration' do
    it 'should fallback on days_difference_between' do
      Rental.any_instance.expects(:days_difference_between).once

      subject.day_duration
    end

    it 'should not re-compute multiple times' do
      object = Rental.new

      object.expects(:days_difference_between).once.returns(3)

      object.day_duration
      object.day_duration
    end
  end

  describe '#price' do
    context 'one day' do
      it 'should compute with basic formula' do
        car = mock

        car.expects(:price_per_day).returns(40)
        car.expects(:price_per_km).returns(1)

        object = Rental.new
        object.instance_variable_set(:@car, car)

        object.expects(:day_duration).returns(1).at_least(2)
        object.expects(:distance).returns 2

        #
        # car.price_per_day * day_duration + car.price_per_km * distance
        # 40 * 1 + 1 * 2 => 40 + 2 => 42
        #
        expected = 42

        expect(object.price).to eq expected
      end
    end
    # Should write tests for other cases below but time is running out
  end
  # Should write tests for other methods below but time is running out
end
