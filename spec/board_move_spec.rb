require_relative 'spec_helper'

RSpec.describe BoardMove do
  context "a pawn moving off the board" do
    include_examples :lets

    subject(:board_move) { described_class.new(board, move) }

    let(:start_position_value) { 'E8' }
    let(:destination_position_value) { 'E9' }

    xit "can't move" do
      ok = board_move.valid?

      expect(ok).to be_falsey
      expect(start_tile).to be_occupied
      expect(start_tile.piece).to eq start_piece
    end
  end
end
