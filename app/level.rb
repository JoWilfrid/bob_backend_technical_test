# frozen_string_literal: true

require 'json'
require 'active_support/core_ext/hash'
require 'models/rental'

class Level
  # Constants
  DATA_FILE_PATH = 'data/data.json'

  def result
    { rental_modifications: @rental_modifications }
  end

  def initialize
    @data = fetch_data
    @last_id = 0
    @last_modif_id = 0
    @rental_modifications = []
  end

  # rubocop:disable Metrics/MethodLength
  def run
    @rental_modifications = @data['rentals'].map do |rental|
      attrs = rental.with_indifferent_access.merge(
        id: @last_id += 1,
        car: find_by_field(@data['cars'], rental['car_id'])
      )
      rental = Rental.new(attrs)
      modification = find_by_field(@data['rental_modifications'], rental.id, 'rental_id')

      next unless modification

      new_rental = rental.dup
      %w[distance start_date end_date].each do |attr|
        new_rental.send("#{attr}=", modification[attr]) unless modification[attr].nil?
      end

      {
        id: @last_modif_id += 1,
        rental_id: modification['rental_id'],
        actions: rental.compute_actions_differences(new_rental)
      }
    end.compact
  end
  # rubocop:enable Metrics/MethodLength

  private

  def fetch_data
    JSON.parse(File.read(DATA_FILE_PATH))
  end

  def find_by_field(collection, id, field = 'id')
    return unless collection

    collection.select { |obj| obj[field] == id }.first
  end
end
