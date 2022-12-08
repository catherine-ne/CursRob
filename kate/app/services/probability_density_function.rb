# frozen_string_literal: true

class ProbabilityDensityFunction
  class << self
    def solve(alpha, beta, x)
      (beta/alpha) * (x/alpha)**(beta-1) / (1 + (x/alpha)**beta)**2
    end

    def mode(alpha, beta)
      alpha*(((beta-1)/(beta+1)).abs)**(1/beta)
    end

    def maximum_value(alpha, beta)
      mode = mode(alpha, beta)
      ProbabilityDensityFunction.solve(alpha, beta, mode)
    end

    def mean(alpha, beta)
      (alpha*(beta/Math::PI)/Math.sin(beta/Math::PI))
    end

    def variance(alpha, beta)
      (alpha**2) * ((2*beta / Math.sin(2*beta)) - (beta**2/Math.sin(beta)**2)).abs
    end

    def deviation(alpha, beta, generation_count)
      variance = ProbabilityDensityFunction.variance(alpha, beta)
      Math.sqrt((variance / generation_count).abs)
    end
  end
end
