# frozen_string_literal: true

require 'models/base_model'
require 'models/car'
require 'helpers/date_helper'
require 'helpers/numeric_helper'

class Rental < BaseModel
  # Inclusions
  include DateHelper
  include NumericHelper

  # Constants
  DECREASE = [] # rubocop:disable Style/MutableConstant
  ACTORS = %i[driver owner insurance assistance drivy].freeze
  TYPE_EXCHANGE = { credit: :debit, debit: :credit }.freeze
  COMMISSION_LEVEL = 0.3
  INSURANCE_PART = 0.5
  ASSISTANCE_DAILY_FEE = 100
  DAILY_DEDUCTIBLE_REDUCTION = 400

  DECREASE.fill(0, 0..1)
  DECREASE.fill(0.1, 2..4)
  DECREASE.fill(0.3, 5..10)
  DECREASE.fill(0.5, 11..3650)
  DECREASE.freeze

  # Attributes
  attr_accessor :id, :distance, :deductible_reduction
  attr_reader :car, :start_date, :end_date

  def start_date=(value)
    @start_date = ensure_date(value)
  end

  def end_date=(value)
    @end_date = ensure_date(value)
  end

  def car=(value)
    @car = ensure_car(value)
  end

  def day_duration
    @day_duration ||= days_difference_between(start_date, end_date)
  end

  def price
    @price ||= integer_unless_float(compute_price)
  end

  def commission
    @commission ||= compute_commission
  end

  def options
    @options ||= compute_options
  end

  def actions(force = false)
    @actions = compute_actions if force
    @actions ||= compute_actions
  end

  def compute_actions_differences(rental)
    original_actions, new_actions = extract_actions(rental)

    original_actions.map do |action|
      new_action = new_actions.select { |act| act[:who] == action[:who] }.first

      next if new_action.nil?

      diff_action = action.dup
      diff_amount = new_action[:amount] - action[:amount]
      diff_action[:amount] = diff_amount.abs
      diff_action[:type] = TYPE_EXCHANGE[diff_action[:type].to_sym] unless diff_amount == diff_amount.abs

      diff_action
    end
  end

  protected

  def extract_actions(rental)
    [actions, rental.actions]
  end

  def compute_options
    { deductible_reduction: compute_deductible_reduction }
  end

  def ensure_date(value)
    value.is_a?(Date) ? value : parse_date(value)
  end

  def ensure_car(value)
    value.is_a?(Car) ? value : Car.new(value)
  end

  def compute_deductible_reduction
    return 0 unless deductible_reduction

    integer_unless_float(day_duration * DAILY_DEDUCTIBLE_REDUCTION)
  end

  def compute_price
    return (car.price_per_day * day_duration + car.price_per_km * distance) if day_duration <= 1

    duration_price = (0..day_duration).to_a.inject do |sum, day|
      day_price = car.price_per_day - car.price_per_day * DECREASE[day]

      sum + day_price
    end

    duration_price + car.price_per_km * distance
  end

  def compute_commission
    commission  = price * COMMISSION_LEVEL
    insurance   = commission * INSURANCE_PART
    assistance  = ASSISTANCE_DAILY_FEE * day_duration

    {
      total_fees: integer_unless_float(commission),
      insurance_fee: integer_unless_float(insurance),
      assistance_fee: integer_unless_float(assistance),
      drivy_fee: integer_unless_float(commission - (insurance + assistance))
    }
  end

  def compute_actions
    self.class::ACTORS.collect do |who|
      send("compute_#{who}_action")
    end
  end

  def compute_driver_action
    debit_to('driver', price + options[:deductible_reduction])
  end

  def compute_owner_action
    credit_to('owner', price - commission[:total_fees])
  end

  def compute_insurance_action
    credit_to('insurance', commission[:insurance_fee])
  end

  def compute_assistance_action
    credit_to('assistance', commission[:assistance_fee])
  end

  def compute_drivy_action
    credit_to('drivy', commission[:drivy_fee] + options[:deductible_reduction])
  end

  def debit_to(who, amount)
    {
      'who': who,
      'type': 'debit',
      'amount': amount
    }
  end

  def credit_to(who, amount)
    {
      'who': who,
      'type': 'credit',
      'amount': amount
    }
  end
end
