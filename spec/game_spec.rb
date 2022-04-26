require './lib/game'
require './lib/colors'
include Colors

describe Game do
  describe "#make_players" do
    subject(:game_players) { described_class.new }
    
    context 'when make_players is called' do 
      it 'sets names for p1 and p2' do
        allow(game_players).to receive(:set_names).and_return("Captain", "Crunch")
        game_players.make_players
        expect(game_players.p1.name).to eq('Captain')
        expect(game_players.p2.name).to eq('Crunch')
      end
    end
  end

  describe '#set_active_player' do
    subject(:sample_player) { described_class.new }

    context 'when p1 is chosen' do
      let(:player) { double('player', name: 'Captain') }
      before do
        sample_player.active_player = player
        allow(sample_player).to receive(:set_active_player).and_return('Captain')
      end
      it 'sets p1 as active player' do
        name = sample_player.set_active_player
        expect(name).to eq('Captain')
      end
    end

    context 'when p2 is chosen' do
      let(:player) { double('player', name: 'Crunch') }
      before do
        sample_player.active_player = player
        allow(sample_player).to receive(:set_active_player).and_return('Crunch')
      end

      it 'sets p2 as active player' do
        name = sample_player.set_active_player
        expect(name).to eq('Crunch')  
      end
    end
  end

  describe '#verify_input' do
    subject(:game_verify) { described_class.new }

    context 'when user input is valid' do
      it 'returns input' do
        input = '5' 
        valid_input = game_verify.verify_input(input)
        expect(valid_input).to eq(5)
      end 
    end

    context 'when user input is invalid ' do
      it 'returns nil' do
        input = 'f'
        invalid_input = game_verify.verify_input(input)
        expect(invalid_input).to eq(nil)
      end
    end
  end

  describe '#user_turn' do
    subject(:game_loop) { described_class.new }
    context 'when user input is valid' do
      it 'exits loop and returns 5' do
        allow(game_loop).to receive(:user_input).and_return('5')
        input = game_loop.user_turn
        expect(input).to eq(5)
      end
    end

    context 'when user input is invalid then valid' do
      it 'loops once, then exits loop and returns 7' do
        allow(game_loop).to receive(:user_input).and_return('8', '7')
        input = game_loop.user_turn
        expect(input).to eq(7)
      end
    end

    context 'when user input is invalid, invalid, valid, invalid' do
      it 'loops twice, then exits loop and returns 1' do
        allow(game_loop).to receive(:user_input).and_return('0', 'f', '1', 'u')
        input = game_loop.user_turn
        expect(input).to eq(1)
      end
    end
  end

  describe '#verify_column' do
    subject(:game_column) { described_class.new }
    context 'when user inputs 1, but column 1 is full' do
      it 'returns nil' do
        allow(game_column).to receive(:column_full?).and_return(true)
        input = 1
        game_column.board[0][input - 1] = yellow_piece
        full = game_column.verify_column(input)
        expect(full).to eq(nil)
      end
    end
  end

  describe '#insert_piece' do
    subject(:populate_game) { described_class.new }
    let(:player_1) { double('player', name: 'red', piece: red_piece) }
    let(:player_2) { double('player', name: 'yellow', piece: yellow_piece) }
    context 'when player 1 chooses column 1 with empty board' do
      before do
        populate_game.active_player = player_1
      end
      it 'insert red piece at row 6, column 1' do
        input = 1
        populate_game.insert_piece(input)
        spot = populate_game.board[5][0]
        expect(spot).to eq(red_piece)
      end
    end

    context 'when player 1 chooses column 1 then player 2 chooses same column(1)' do
      before do
        populate_game.active_player = player_1
        red_player_input = 1
        populate_game.insert_piece(red_player_input)
        populate_game.active_player = player_2
      end
      it 'insert yellow piece at row 5, column 1' do
        yellow_player_input = 1
        populate_game.insert_piece(yellow_player_input)
        spot = populate_game.board[4][0]
        expect(spot).to eq(yellow_piece)
      end
    end

    context 'when player 2 chooses column 7 last spot(very top)' do
      before do
        5.downto(1) { |i| populate_game.board[i][6] = red_piece}
        populate_game.active_player = player_2
      end
      it 'insert yellow piece at row 1, column 7' do
        input = 7
        populate_game.insert_piece(input)
        spot = populate_game.board[0][6]
        expect(spot).to eq(yellow_piece)
      end
    end
  end

  describe '#switch_active_player' do
    subject(:game_switch) { described_class.new }
    let(:player_1) { double('player', name: 'Capitan', piece: red_piece) }
    let(:player_2) { double('player', name: 'Ship', piece: yellow_piece) }
    context 'when player 1\'s turn is finish' do
      before do
        game_switch.p1 = player_1
        game_switch.p2 = player_2
        game_switch.active_player = player_1
      end
      it 'switch active player to player 2' do
        game_switch.switch_active_player
        active = game_switch.active_player
        expect(active).to eq(player_2)
      end
    end

    context 'when player 2\'s turn is completed' do
      before do
        game_switch.p1 = player_1
        game_switch.p2 = player_2
        game_switch.active_player = player_2
      end
      it 'switch over to player 1\'s turn' do
        game_switch.switch_active_player
        active = game_switch.active_player
        expect(active).to eq(player_1)
      end
    end
  end

  describe '#game_over?' do
    subject(:game_finish) { described_class.new }
    context 'when a full board is discovered' do
      it 'returns true' do
        game_finish.board = Array.new(6) { Array.new(7) { yellow_piece } }
        expect(game_finish.game_over?).to eq(true)
      end
    end

    context 'when a win has been discovered' do
      before do
        game_finish.active_player = game_finish.p1
        row_start = (0..2).to_a.sample
        column_start = (3..6).to_a.sample
        4.times { |i| game_finish.board[i + row_start][column_start - i] = red_piece }
      end
      it 'returns true' do
        expect(game_finish.game_over?).to eq(true)
      end
    end
  end

  describe '#build_board' do
    context 'when building board' do
      subject(:game_build) { described_class.new }
    
      it 'ouputs 6 rows of empty spaces' do
        row = ""
        7.times { row += blank_space }
        expect(game_build).to receive(:puts).with(row).exactly(6).times
        game_build.build_board
      end
    end
  end

  describe '#column_full?' do
    subject(:game_columns) { described_class.new }
    context 'when user inputs 3, but column cannot hold more pieces' do
      it 'returns false' do
        input = 3
        game_columns.board[0][input - 1] = yellow_piece
        column_full = game_columns.column_full?(input)
        expect(column_full).to eq(true)
      end
    end

    context 'when user inputs 6, and column can hold another piece' do
      it 'returns false' do
        input = 6
        column_full = game_columns.column_full?(input)
        expect(column_full).not_to eq(true)
      end
    end
  end

  describe '#full_board?' do
    subject(:game_full) { described_class.new }
    context 'when board is full' do
      it 'returns true' do
        game_full.board = Array.new(6) { Array.new(7) { yellow_piece } }
        is_full = game_full.full_board?
        expect(is_full).to eq(true)
      end
    end

    context 'when board is NOT full' do
      it 'returns false' do
        is_full = game_full.full_board?
        expect(is_full).not_to eq(true)
      end
    end
  end

  describe '#row_win?' do
    describe 'given a red piece as active_player' do 
      subject(:game_check) { described_class.new }
      let(:player_1) { double('player', name: 'Hungry', piece: red_piece) }
      context 'when top row is all red pieces' do
        before do
          game_check.active_player = player_1
          row = (0..5).to_a.sample                                              #index 0-5 all should work
          game_check.board[row].map! { |e| e = red_piece }
        end
        it 'returns true' do
          expect(game_check.row_win?).to eq(true) 
        end
      end

      context 'when a row contains 3 reds, 1 yellow, 3 reds' do
        before do
          game_check.active_player = player_1
          game_check.board[3].map! { |e| e = red_piece }
          game_check.board[3][3] = yellow_piece
        end
        it 'returns false' do
          expect(game_check.row_win?).to eq(false)
        end
      end
    end
  end

  describe '#column_win?' do
    describe 'given a yellow piece as active_player' do
      subject(:game_check) { described_class.new }
      let(:player) { double('player', name: 'ughtests', piece: yellow_piece) }
      context 'when a column contains 2 reds, 4 yellows' do
        before do
          game_check.active_player = player
          column = (0..6).to_a.sample                                           #index 0-6 should all work
          2.times { |i| game_check.board[5 - i][column] = red_piece }
          4.times { |i| game_check.board[i][column] = yellow_piece }
        end
        it 'returns true' do
          expect(game_check.column_win?).to eq(true)
        end
      end
    end
  end

  describe '#diagonal_win?' do
    describe 'given a red piece as active_player' do
      subject(:game_check) { described_class.new }
      let(:player) { double('player', name: 'ughtests', piece: red_piece) }
      context 'when 4 reds are diagonally rightward(\\)' do
        before do
          game_check.active_player = player
          row_start = (0..2).to_a.sample                                        #index 0-2. start of row diagonal 
          column_start = (0..3).to_a.sample                                     #index 0-3. start of column diagonal
          4.times { |i| game_check.board[i + row_start][i + column_start] = red_piece }
        end
        it 'returns true' do
          expect(game_check.diagonal_win?).to eq(true)
        end
      end

      context 'when 4 reds are diagonally leftwards(/)' do
        before do
          game_check.active_player = player
          row_start = (0..2).to_a.sample                                        #index 0-2. start of row diagonal
          column_start = (3..6).to_a.sample                                     #index 3-6. start of column diagonal
          4.times { |i| game_check.board[i + row_start][column_start - i] = red_piece }
        end
        it 'returns true' do
          expect(game_check.diagonal_win?).to eq(true)
        end
      end
    end
  end
end