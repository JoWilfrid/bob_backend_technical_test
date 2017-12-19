# frozen_string_literal: true

require 'date'

module DateHelper
  def parse_date(date_string)
    date_params = date_string.split('-').collect(&:to_i)
    Date.new(*date_params)
  end

  def days_difference_between(start_date, end_date, include_all = true)
    days = (end_date - start_date).to_i
    days += 1 if include_all

    days
  end
end
