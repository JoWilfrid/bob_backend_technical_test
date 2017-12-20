# frozen_string_literal: true

require 'json'
require 'formatters/rental_formatter'

class Level
  # Constants
  DATA_FILE_PATH = 'data/data.json'

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
      attrs = rental.with_indifferent_access.merge(
        id: @last_id += 1,
        car: find_car_by_id(@data['cars'], rental['car_id'])
      )
      rental = Rental.new(attrs)

      RentalFormatter.format(rental)
    end
  end

  private

  def fetch_data
    JSON.parse(File.read(DATA_FILE_PATH))
  end

  def find_car_by_id(cars, id)
    cars.select { |car| car['id'] == id }.first
  end
end
