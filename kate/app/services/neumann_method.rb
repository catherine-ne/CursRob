# frozen_string_literal: true

class NeumannMethod
  class << self
    def calculate(function_callback, maximum_value, right_boundary)
      loop do

        x = rand * right_boundary
        y = rand * maximum_value

        return x.abs if function_callback.call(x) > y.abs
      end
    end
  end
end
