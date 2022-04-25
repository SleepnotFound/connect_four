require './lib/game'

describe Game do
  describe '#build_board' do
    context 'when building board' do
      subject(:game_build) { described_class.new }
      
      it 'ouputs 6 rows of empty spaces' do
        row = ""
        7.times { row += " \u25CB " }
        expect(game_build).to receive(:puts).with(row).exactly(6).times
        game_build.build_board
      end
    end
  end

  describe "#make_players" do
    context 'when make_players is called' do 
      subject(:game_players) { described_class.new }

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

  describe '#insert_piece' do
    subject(:populate_game) { described_class.new }
    context 'when player 1 chooses column 1 with empty board' do
      let(:player_1) { double('player', name: 'Captain', piece: " \e[31m\u25CF\e[0m ") }
      before do
        populate_game.active_player = player_1
      end
      it 'insert red piece at row 6, column 1' do
        input = 1
        populate_game.insert_piece(input)
        spot = populate_game.board[5][0]
        expect(spot).to eq(" \e[31m\u25CF\e[0m ")
      end
    end

    context 'when player 1 chooses column 1 then player 2 chooses same column(1)' do
      let(:player_1) { double('player', name: 'Captain', piece: " \e[31m\u25CF\e[0m ") }
      let(:player_2) { double('player', name: 'Crunch', piece: " \e[33m\u25CF\e[0m ") }
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
        expect(spot).to eq(" \e[33m\u25CF\e[0m ")
      end
    end

    context 'when player 2 chooses column 7 last spot(very top)' do
      let(:player_2) { double('player', name: 'Crunch', piece: " \e[33m\u25CF\e[0m ") }
      before do
        populate_game.board[5][6] = " \e[31m\u25CF\e[0m "
        populate_game.board[4][6] = " \e[33m\u25CF\e[0m "
        populate_game.board[3][6] = " \e[31m\u25CF\e[0m "
        populate_game.board[2][6] = " \e[33m\u25CF\e[0m "
        populate_game.board[1][6] = " \e[31m\u25CF\e[0m "
        populate_game.active_player = player_2
      end
      it 'insert yellow piece at row 1, column 7' do
        input = 7
        populate_game.insert_piece(input)
        spot = populate_game.board[0][6]
        expect(spot).to eq(" \e[33m\u25CF\e[0m ")
      end
    end
  end

end