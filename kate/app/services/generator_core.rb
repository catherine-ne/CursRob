# frozen_string_literal: true

class GeneratorCore
  def initialize(limit, step, sample_size)
    @sample_size = sample_size
    @limit = limit
    @step = step
  end

  def total_generations_count
    (@limit.to_f / @step) * @sample_size
  end

  def generate(method)
    zeroing_class_data
    process(method)
    build_result
  end

  private

  def process(method)
    distribution_range.step(@step).each do |current_step|
      current_success_method_results = 0
      previous_step = current_step - @step

      (0..@sample_size).each do
        method_result = method.call
        @sum += method_result
        @sum_squares += method_result**2

        current_success_method_results += 1 if (method_result > previous_step) && (method_result <= current_step)
      end

      @frequencies.push(current_success_method_results.to_f / @sample_size)
    end
  end

  def zeroing_class_data
    @frequencies = []
    @sum = 0
    @sum_squares = 0
  end

  def build_result
    {
      'frequencies' => @frequencies,
      'sum' => @sum,
      'sum_squares' => @sum_squares
    }
  end

  def distribution_range
    (0 + @step)..@limit
  end
end
