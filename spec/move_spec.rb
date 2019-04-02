require 'spec_helper'

RSpec.describe Move do
  include_examples :lets

  let(:start_position_value) { 'B2' }
  let(:destination_position_value) { 'E9' }

  describe '#free_corridor?' do
    it "is true when no other piece is on the way (rook)" do
      expect(described_class.new(board, 'A1', 'A2')).to be_truthy

      move = described_class.new(board, 'A2', 'A7')

      expect(move).to be_free_corridor
    end

    it "is false when another piece is on the way (rook)" do
      move = described_class.new(board, 'A1', 'A5')

      expect(move).not_to be_free_corridor
    end

    it "is true when no other piece is on the way (bishop)" do
      board.tile_at('B2').piece = Pieces::Null.new
      move = described_class.new(board, 'C1', 'A4')

      expect(move).to be_free_corridor
    end

    it "is false when another piece is on the way (bishop)" do
      move = described_class.new(board, 'C1', 'E3')

      expect(move).not_to be_free_corridor
    end
  end

  describe '#standing?' do
    it "is standing when the start is the destination" do
      expect(described_class.new(board, start_position_value, start_position_value))
        .to be_standing
    end

    it "is NOT standing when the start is the destination" do
      expect(described_class.new(board, start_position_value, destination_position_value))
        .not_to be_standing
    end
  end
end
