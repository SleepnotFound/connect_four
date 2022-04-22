require './lib/game'

describe Game do
  describe '#build_board' do
    subject(:game_build) { described_class.new }
    
    it 'ouputs 6 rows of empty spaces' do
      row = ""
      7.times { row += " \u25CB " }
      expect(game_build).to receive(:puts).with(row).exactly(6).times
      game_build.build_board
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

end