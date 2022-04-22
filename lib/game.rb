require_relative 'colors'
require_relative 'player'

class Game
  include Colors
  attr_accessor :board, :p1, :p2

  def initialize
    @board = Array.new(6) { Array.new(7) { blank_space } }
    @p1 = Player.new(nil, red_piece)
    @p2 = Player.new(nil, yellow_piece)
  end

  def build_board
    board.each do |row| 
      puts row.reduce { |row, cell| row + cell }
    end
    #puts ' 1  2  3  4  5  6  7 '
  end

  #play should only be script. only test methods inside
  def play
    build_board
    puts ' 1  2  3  4  5  6  7 '
    make_players
    p p1
  end

  def make_players
    #set names for p1 and p2
    self.p1.name = set_names(1)
    self.p2.name = set_names(2)
  end
  #set_names should only have puts and gets to skip testing phase
  def set_names(id)
    puts "enter name for player #{id}"
    gets.chomp
  end

end

game = Game.new
game.play