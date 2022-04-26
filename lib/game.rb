require_relative 'colors'
require_relative 'player'
require_relative 'board'

class Game < Board
  include Colors
  attr_accessor :board, :p1, :p2, :active_player

  def initialize
    @board = Array.new(6) { Array.new(7) { blank_space } }
    @p1 = Player.new(nil, red_piece)
    @p2 = Player.new(nil, yellow_piece)
    @active_player = nil
  end

  def play
    make_players
    set_active_player
    puts "#{active_player.name} goes first!"
    
    loop do 
      build_board
      puts ' 1  2  3  4  5  6  7 '
      puts "#{active_player.name} goes next!(#{active_player.piece})"
      insert_piece(user_turn)
      break if game_over?
      switch_active_player
    end
    show_results
  end

  def show_results
    if full_board?
      puts 'Tie!'
    else
      build_board
      puts "#{active_player.name} has won!"
    end
  end

  def make_players
    self.p1.name = set_names(1)
    self.p2.name = set_names(2)
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
      input = verify_column(input) if input
    end
    input
  end

  def verify_column(input)
    return input unless column_full?(input)
    puts 'Column is full! try again'
    nil
  end
  
  def insert_piece(input)
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

  def game_over?
    full_board? || row_win? || column_win? || diagonal_win?
  end
  
  private

  def user_input
    puts "Enter a number between 1-7"
    gets.chomp
  end

  def set_names(id)
    puts "enter name for player #{id}"
    gets.chomp
  end
end