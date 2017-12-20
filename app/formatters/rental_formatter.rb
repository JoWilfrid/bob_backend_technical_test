# frozen_string_literal: true

class RentalFormatter
  def format(*args)
    self.class.format(*args)
  end

  class << self
    def format(rental)
      {
        id: rental.id,
        actions: rental.actions
      }
    end
  end
end
