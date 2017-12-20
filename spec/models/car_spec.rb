# frozen_string_literal: true

require 'models/car'

RSpec.describe Car do
  describe '#initialize' do
    it 'should init without params' do
      expect(Car.new).not_to be_nil
    end

    it 'should not set any attributes if not declared' do
      object = Car.new(foo: :bar)

      expect(object.instance_variable_get(:@foo)).to be_nil
    end

    it 'should set attributes if declared' do
      object = Car.new(
        id: 1,
        price_per_day: 2,
        price_per_km: 3
      )

      expect(object.instance_variable_get(:@id)).to eq 1
      expect(object.instance_variable_get(:@price_per_day)).to eq 2
      expect(object.instance_variable_get(:@price_per_km)).to eq 3
    end
  end
end
