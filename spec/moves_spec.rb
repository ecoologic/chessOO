require_relative 'spec_helper'

RSpec.describe Moves::Knight do
  let(:start_tile) { Tile.new('E4', Pieces::Knight.new) }
  let(:valid_destination_tile) { Tile.new('G5') }
  let(:invalid_destination_tile) { Tile.new('E3') }

  let(:valid_move) { Move.new(start_tile, valid_destination_tile) }
  let(:invalid_move) { Move.new(start_tile, invalid_destination_tile) }

  describe '#valid_move?' do
    it "is valid when you move one up and two left" do
      allow(valid_move).to receive(:in_board?).and_return(true)

      expect(described_class.new(valid_move).valid_move?).to be true
    end

    it "is invalid when try to move like a pawn" do
      allow(valid_move).to receive(:in_board?).and_return(true)

      expect(described_class.new(invalid_move).valid_move?).to be false
    end
  end
end
