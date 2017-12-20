# frozen_string_literal: true

module NumericHelper
  def integer_unless_float(number)
    return number.to_i if number.to_i.to_f == number.to_f

    number.to_f
  end
end
