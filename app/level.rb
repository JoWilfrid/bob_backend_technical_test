# frozen_string_literal: true

require 'json'
require 'helpers/date_helper'

class Level
  # Includes
  include DateHelper

  # Constants
  DATA_FILE_PATH = 'data/data.json'
  DECREASE = [] # rubocop:disable Style/MutableConstant
  COMMISSION_LEVEL = 0.3
  INSURANCE_PART = 0.5
  ASSISTANCE_DAILY_FEE = 100

  DECREASE.fill(0, 0..1)
  DECREASE.fill(0.1, 2..4)
  DECREASE.fill(0.3, 5..10)
  DECREASE.fill(0.5, 11..3650)
  DECREASE.freeze

  def result
    { rentals: @rentals }
  end

  def initialize
    @data = fetch_data
    @last_id = 0
    @rentals = []
  end

  def run
    @rentals = @data['rentals'].map do |rental|
      days, price = extract_and_compute_data_from(rental)

      {
        id: @last_id += 1,
        price: price,
        commission: fees_from_price(price, days)
      }
    end
  end

  private

  def fetch_data
    JSON.parse(File.read(DATA_FILE_PATH))
  end

  def find_car_by_id(cars, id)
    cars.select { |car| car['id'] == id }.first
  end

  def rental_price(car, days, distance)
    return (car['price_per_day'] * days + car['price_per_km'] * distance) if days <= 1

    duration_price = (0..days).to_a.inject do |sum, day|
      day_price = car['price_per_day'] - car['price_per_day'] * DECREASE[day]
      sum + day_price
    end

    duration_price + car['price_per_km'] * distance
  end

  def fees_from_price(price, days)
    commission = price * COMMISSION_LEVEL
    insurance = commission * INSURANCE_PART
    assistance = ASSISTANCE_DAILY_FEE * days

    {
      insurance_fee: insurance,
      assistance_fee: assistance,
      drivy_fee: commission - (insurance + assistance)
    }
  end

  def extract_and_compute_data_from(rental)
    start_date = parse_date(rental['start_date'])
    end_date = parse_date(rental['end_date'])
    days = days_difference_between(start_date, end_date)
    car = find_car_by_id(@data['cars'], rental['car_id'])
    price = rental_price(car, days, rental['distance'])

    [days, price]
  end
end
