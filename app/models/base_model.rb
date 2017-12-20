# frozen_string_literal: true

require 'active_support/core_ext/hash'

class BaseModel
  def initialize(attrs = {})
    attrs.each do |name, value|
      try("#{name}=", value)
    end
  end
end
