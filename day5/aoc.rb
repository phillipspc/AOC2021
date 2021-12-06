require 'pry'

input = File.read("./input.txt").lines.map do |line|
  coords = []
  line.strip.split(" -> ").each { |group| coords << group.split(",").map(&:to_i) }
  coords
end

class Grid
  def initialize(array_of_coords)
    @lines = array_of_coords.map { |coords| Line.new(coords) }
    @lines = @lines.select(&:horizontal_or_vertical?)
    @x_values = (0..999).to_a
    @y_values = (0..999).to_a
  end

  def find_overlapping_line_points
    count = 0
    x_values.each do |x|
      y_values.each do |y|
        lines_crossing_point = lines.select do |line|
          line.crosses_point?(x, y)
        end

        count += 1 if lines_crossing_point.count >= 2
      end
    end

    p count
  end

  private

  attr_reader :lines, :x_values, :y_values
end

class Line
  def initialize(coords)
    @start = Point.new(coords.first.first, coords.first.last)
    @stop = Point.new(coords.last.first, coords.last.last)
  end

  def horizontal?
    start.y == stop.y
  end

  def vertical?
    start.x == stop.x
  end

  def horizontal_or_vertical?
    horizontal? || vertical?
  end

  def crosses_point?(x, y)
    point_is_start?(x, y) ||
      point_is_stop?(x, y) ||
      horizontal_and_contains_point?(x, y) ||
      vertical_and_contains_point?(x, y)
  end

  private

  attr_reader :start, :stop

  def point_is_start?(x, y)
    start.x == x && start.y == y
  end

  def point_is_stop?(x, y)
    stop.x == x && stop.y == y
  end

  def horizontal_and_contains_point?(x, y)
    horizontal? && y == start.y && x.between?(lowest_x, highest_x)
  end

  def vertical_and_contains_point?(x, y)
    vertical? && x == start.x && y.between?(lowest_y, highest_y)
  end

  def lowest_x
    sorted_x.first
  end

  def highest_x
    sorted_x.last
  end

  def lowest_y
    sorted_y.first
  end

  def highest_y
    sorted_y.last
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

p Grid.new(input).find_overlapping_line_points
