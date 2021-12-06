require 'pry'

input = File.read("./input.txt").lines.map do |line|
  coords = []
  line.strip.split(" -> ").each { |group| coords << group.split(",").map(&:to_i) }
  coords
end

class Grid
  def initialize(array_of_coords)
    @lines = array_of_coords.map { |coords| Line.new(coords) }
    @x_values = (0..999).to_a
    @y_values = (0..999).to_a
  end

  def number_of_points_covered_by_at_least_two_lines
    all_points_covered_by_all_lines.tally.reject { |_, v| v == 1 }.count
  end

  private

  attr_reader :lines, :x_values, :y_values

  def all_points_covered_by_all_lines
    lines.flat_map(&:points_covered)
  end
end

class Line
  def initialize(coords)
    @start = Point.new(coords.first.first, coords.first.last)
    @stop = Point.new(coords.last.first, coords.last.last)
  end

  def points_covered
    if horizontal?
      (lowest_x..highest_x).to_a.map { |x| [x, start.y] }
    elsif vertical?
      (lowest_y..highest_y).to_a.map { |y| [start.x, y] }
    else # diagonal
      delta = highest_x - lowest_x
      (delta + 1).times.map do |i|
        new_x = start.x + (i * x_mod)
        new_y = start.y + (i * y_mod)
        [new_x, new_y]
      end
    end
  end

  private

  attr_reader :start, :stop

  def horizontal?
    start.y == stop.y
  end

  def vertical?
    start.x == stop.x
  end

  def lowest_x
    sorted_x.first
  end

  def highest_x
    sorted_x.last
  end

  def x_mod
    (stop.x - start.x) / (highest_x - lowest_x)
  end

  def lowest_y
    sorted_y.first
  end

  def highest_y
    sorted_y.last
  end

  def y_mod
    (stop.y - start.y) / (highest_y - lowest_y)
  end

  def sorted_x
    @sorted_x = [start.x, stop.x].sort
  end

  def sorted_y
    @sorted_y = [start.y, stop.y].sort
  end
end

class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_reader :x, :y
end

p Grid.new(input).number_of_points_covered_by_at_least_two_lines
