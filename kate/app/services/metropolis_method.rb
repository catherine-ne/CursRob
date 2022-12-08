# frozen_string_literal: true

class MetropolisMethod
  class << self
    def calculate(function_callback, right_boundary, previous_x)
      gamma1 = rand
      gamma2 = rand
      delta = (1.0 / 3.0) * right_boundary
      x1 = previous_x + delta * (-1.0 + 2.0 * gamma1)
      return previous_x if x1.negative? || x1 > right_boundary
      p "==========#{x1}"

      previous_x_calculation = function_callback.call(previous_x)
      alpha = function_callback.call(x1) / previous_x_calculation

      return x1 if alpha >= 1.0 || alpha > gamma2

      previous_x
    end
  end
end
