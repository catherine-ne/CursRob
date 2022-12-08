# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def index
    @sample_size = params['sample-size']
    @max_x =  params['right-boundary']
    @alpha =  params['alpha']
    @beta =   params['beta']
    @step = 0.1

    return unless @sample_size && @max_x && @alpha && @beta

    @sample_size = @sample_size.to_i
    @max_x = @max_x.to_f
    @alpha = @alpha.to_f
    @beta = @beta.to_f

    return unless @sample_size > 1 || @max_x.positive? || @alpha.positive?

    generator = GeneratorCore.new(@max_x, @step, @sample_size)
    total_generations_count = generator.total_generations_count

    pdf_calculation_lambda = ->(x) { ProbabilityDensityFunction.solve(@alpha, @beta, x) }
    pdf_mode_value         = ProbabilityDensityFunction.mode(@alpha, @beta)
    pdf_mean_value         = ProbabilityDensityFunction.mean(@alpha, @beta)
    pdf_variance_value     = ProbabilityDensityFunction.variance(@alpha, @beta)
    pdf_deviation_value    = ProbabilityDensityFunction.deviation(@alpha, @beta, total_generations_count)
    pdf_maximum_value      = ProbabilityDensityFunction.maximum_value(@alpha, @beta)

    neumann_method_lambda = -> { NeumannMethod.calculate(pdf_calculation_lambda, pdf_maximum_value, @max_x) }

    previous_x_result = pdf_mode_value
    metropolis_method_lambda = lambda {
      calculation_result = MetropolisMethod.calculate(pdf_calculation_lambda, @max_x, previous_x_result)
      previous_x_result = calculation_result
      calculation_result
    }

    piecewise_sum_h = PiecewiseApproximationMethod.calculate_sum_h(pdf_calculation_lambda, @max_x)
    piecewise_approximation_lambda = lambda {
      PiecewiseApproximationMethod.calculate(pdf_calculation_lambda, @max_x, piecewise_sum_h)
    }

    neumann_method_data = generator.generate(neumann_method_lambda)
    metropolis_method_data = generator.generate(metropolis_method_lambda)
    piecewise_approximation_data = generator.generate(piecewise_approximation_lambda)

    neumann_method_expected = MethodCalculationUtils.get_mean(
      total_generations_count,
      neumann_method_data['sum']
    )
    metropolis_method_expected = MethodCalculationUtils.get_mean(
      total_generations_count,
      metropolis_method_data['sum']
    )
    piecewise_method_expected = MethodCalculationUtils.get_mean(
      total_generations_count,
      piecewise_approximation_data['sum']
    )

    neumann_method_variance = MethodCalculationUtils.get_variance(
      total_generations_count,
      neumann_method_data['sum'],
      neumann_method_data['sum_squares']
    )
    metropolis_method_variance = MethodCalculationUtils.get_variance(
      total_generations_count,
      metropolis_method_data['sum'],
      metropolis_method_data['sum_squares']
    )
    piecewise_method_variance = MethodCalculationUtils.get_variance(
      total_generations_count,
      piecewise_approximation_data['sum'],
      piecewise_approximation_data['sum_squares']
    )

    neumann_method_deviation = MethodCalculationUtils.get_deviation(
      total_generations_count,
      neumann_method_data['sum'],
      neumann_method_data['sum_squares']
    )
    metropolis_method_deviation = MethodCalculationUtils.get_deviation(
      total_generations_count,
      metropolis_method_data['sum'],
      metropolis_method_data['sum_squares']
    )
    piecewise_method_deviation = MethodCalculationUtils.get_deviation(
      total_generations_count,
      piecewise_approximation_data['sum'],
      piecewise_approximation_data['sum_squares']
    )

    @calculation_result = {
      'options' => {
        'sampleSize' => @sample_size,
        'max_x' => @max_x,
        'step'  => @step,
        'alpha' => @alpha,
        'beta'  => @beta
      },
      'pdfMaxValue' => pdf_maximum_value,
      'pdfModeValue' => pdf_mode_value,
      'pdfMeanValue' => pdf_mean_value,
      'pdfVarianceValue' => pdf_variance_value,
      'pdfDeviationValue' => pdf_deviation_value,
      'neumannMethod' => neumann_method_data['frequencies'],
      'metropolisMethod' => metropolis_method_data['frequencies'],
      'piecewiseApproximationMethod' => piecewise_approximation_data['frequencies'],
      'neumannMethodExpectedValue' => neumann_method_expected,
      'metropolisMethodExpectedValue' => metropolis_method_expected,
      'piecewiseMethodExpectedValue' => piecewise_method_expected,
      'neumannMethodVariance' => neumann_method_variance,
      'metropolisMethodVariance' => metropolis_method_variance,
      'piecewiseMethodVariance' => piecewise_method_variance,
      'neumannMethodDeviation' => neumann_method_deviation,
      'metropolisMethodDeviation' => metropolis_method_deviation,
      'piecewiseMethodDeviation' => piecewise_method_deviation
    }
  end
end
