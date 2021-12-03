require 'pry'

class OxygenGeneratorRating
  def self.call(...)
    new(...).call
  end

  def initialize(input:, index_to_consider: 0)
    @input = input
    @index_to_consider = index_to_consider
  end

  def call
    return input_as_decimal if input.one?

    new_input = filtered_inputs
    self.class.call(input: new_input, index_to_consider: index_to_consider + 1)
  end

  private
  attr_reader :input, :index_to_consider

  def filtered_inputs
    input.select { |el| el[index_to_consider] == most_common_number }
  end

  def transposed
    @transposed ||= input.transpose
  end

  def most_common_number
    @most_common_number ||= transposed[index_to_consider].sum >= (input.length.to_f/2) ? 1 : 0
  end

  def input_as_decimal
    input.first.join.to_i(2)
  end
end

class CO2ScrubberRating < OxygenGeneratorRating
  private
  def filtered_inputs
    input.select { |el| el[index_to_consider] != most_common_number }
  end
end

input = File.read("input.txt").lines.map { |row| row.strip.split("").map(&:to_i) }

oxygen = OxygenGeneratorRating.call(input: input)
co2 = CO2ScrubberRating.call(input: input)


p oxygen * co2
