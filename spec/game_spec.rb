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

end