# frozen_string_literal: true

require 'models/base_model'

class Car < BaseModel
  # Attributes
  attr_accessor :id
  attr_accessor :price_per_day
  attr_accessor :price_per_km
end
