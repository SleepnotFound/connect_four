require_relative 'colors'
require_relative 'player'

class Game
  include Colors
  attr_accessor :board, :p1, :p2, :active_player

  def initialize
    @board = Array.new(6) { Array.new(7) { blank_space } }
    @p1 = Player.new(nil, red_piece)
    @p2 = Player.new(nil, yellow_piece)
    @active_player = nil
  end

  def build_board
    board.each do |row| 
      puts row.reduce { |row, cell| row + cell }
    end
  end

  #play should only be script. only test methods inside
  def play
    make_players
    set_active_player
    puts "#{active_player.name} goes first!"
    build_board
    puts ' 1  2  3  4  5  6  7 '
    user_turn
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

  def set_active_player
    self.active_player = [@p1, @p2].sample 
  end

  def verify_input(input)
    return input.to_i if input.match?(/^[1-7]$/)
  end

  def user_turn 
    input = nil
    until input 
      input = verify_input(user_input)
    end
    input
  end

  def user_input
    puts "Enter a number between 1-7"
    gets.chomp
  end
  
  def insert_piece(input)
    #reverse_each starts at lowest row towards the highest row
    board.reverse_each do |row|
      if row[input - 1] == blank_space 
        row[input - 1] = active_player.piece
        break
      end
    end
  end

  def switch_active_player 
    self.active_player = active_player == p1 ? p2 : p1 
  end

  def full_board? 
    board.each do |row| 
      return false if row.any? { |spot| spot == blank_space }
    end
    true
  end
end

#game = Game.new
#game.play