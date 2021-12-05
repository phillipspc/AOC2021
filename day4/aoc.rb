require 'pry'

class Bingo
  def initialize(board_data:, numbers:)
    @boards = board_data.map { |data| Board.new(data) }
    @numbers = numbers
  end

  def check_for_winning_board
    numbers_called = []
    winning_board = nil

    numbers.each do |number|
      if winning_board && boards_to_check.empty?
        p winning_board.score
        break
      end

      numbers_called << number
      boards_to_check.each { |board| board.numbers_called = numbers_called }
      winning_board = boards_to_check.select(&:row_or_column_complete?).first
    end
  end

  private

  attr_reader :boards, :numbers

  def boards_to_check
    boards.reject(&:won)
  end
end

class Board
  attr_accessor :numbers_called
  attr_reader :won

  def initialize(data)
    @rows = data
    @columns = data.transpose
    @won = false
  end

  def row_or_column_complete?
    return false if numbers_called.empty?

    if @rows.any? { |row| all_marked?(row) } ||
       @columns.any? { |column| all_marked?(column) }
      @won = true
      return true
    end

    false
  end

  def score
    rows.flatten.reject { |int| numbers_called.include?(int) }.sum * numbers_called.last
  end

  private

  attr_reader :rows, :columns

  def all_marked?(array_of_5_integers)
    array_of_5_integers.all? { |i| numbers_called.include?(i) }
  end
end

numbers, boards = [nil, []]
board = []
input = File.read("./input.txt").lines.each_with_index do |row, i|
  if i == 0
    numbers = row.strip.split(",").map(&:to_i)
  elsif row == "\n"
    next
  else
    board << row.strip.split(" ").map(&:to_i)
  end

  if board.count == 5
    boards << board
    board = []
  end
end

Bingo.new(board_data: boards, numbers: numbers).check_for_winning_board
