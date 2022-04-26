class Board
  def build_board
    board.each do |row| 
      puts row.reduce { |row, cell| row + cell }
    end
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

  def full_board? 
    board.each do |row| 
      return false if row.any? { |spot| spot == blank_space }
    end
    true
  end
end