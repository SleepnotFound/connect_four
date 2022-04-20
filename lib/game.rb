require_relative 'colors'

class Game
  include Colors

  def build_board
    board = Array.new(6) { Array.new(7) { blank_space } }
    board.each do |row| 
      puts row.reduce { |row, cell| row + cell }
    end
  end
end