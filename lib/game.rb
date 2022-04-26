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
    
    loop do 
      build_board
      puts ' 1  2  3  4  5  6  7 '
      puts "#{active_player.name} goes next!(#{active_player.piece})"
      insert_piece(user_turn)
      break if game_over?
      switch_active_player
    end
    if full_board?
      puts 'Tie!'
    else
      build_board
      puts "#{active_player.name} has won!"
    end
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
      input = verify_column(input) if input
    end
    input
  end

  def verify_column(input)
    return input unless column_full?(input)
    puts 'Column is full! try again'
    nil
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

  def column_full?(input)
    return false if board[0][input - 1] == blank_space
    true
  end

  def row_win?
    count = 0
    5.downto(0) do |r|
      7.times do |c|
        if board[r][c] == active_player.piece
          count += 1
        else 
          count = 0
        end
        break if count == 4 
      end
      break if count == 4
    end
    return count == 4 ? true : false
  end

  def column_win?
    count = 0
    7.times do |c|
      6.times do |r|
        if board[r][c] == active_player.piece
          count += 1
        else
          count = 0
        end
        break if count == 4
      end
      break if count == 4
    end
    return count == 4 ? true : false
  end

  def diagonal_win?
    four_piece = []
    0.upto(2) do |r|
      0.upto(3) do |c|
        4.times do |i|
          match = board[r + i][c + i] == active_player.piece
          four_piece.push << match
        end
        return true if four_piece.all?
        four_piece = []
      end
      3.upto(6) do |c|
        4.times do |i|
          match = board[r + i][c - i] == active_player.piece
          four_piece.push << match
        end
        return true if four_piece.all?
        four_piece = []
      end
    end
    false
  end

  def game_over?
    full_board? || row_win? || column_win? || diagonal_win?
  end
end