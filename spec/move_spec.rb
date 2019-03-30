require 'spec_helper'

RSpec.describe Move do
  include_examples :lets

  subject(:move) { described_class.new(board, start_tile, destination_tile) }

  let(:start_position_value) { 'B2' }
  let(:destination_position_value) { 'E9' }

  describe '#free_corridor?' do
    it "is true when no other piece is on the way (tower)" do
      expect(described_class.new(board, board.tile_at('A1'), board.tile_at('A2'))).to be_truthy

      move = described_class.new(board, board.tile_at('A2'), board.tile_at('A7'))

      expect(move).to be_free_corridor
    end

    it "is false when another piece is on the way (tower)" do
      move = described_class.new(board, board.tile_at('A1'), board.tile_at('A5'))

      expect(move).not_to be_free_corridor
    end

    it "is true when no other piece is on the way (bishop)" do
      board.tile_at('B2').piece = Pieces::Null.new
      move = described_class.new(board, board.tile_at('C1'), board.tile_at('A4'))

      expect(move).to be_free_corridor
    end

    it "is false when another piece is on the way (bishop)" do
      move = described_class.new(board, board.tile_at('C1'), board.tile_at('E3'))

      expect(move).not_to be_free_corridor
    end
  end

  describe '#standing?' do
    it "is standing when the start is the destination" do
      expect(described_class.new(board, start_tile, start_tile)).to be_standing
    end

    it "is NOT standing when the start is the destination" do
      expect(described_class.new(board, start_tile, destination_tile)).not_to be_standing
    end
  end
  
  describe '#call' do
    context "a pawn attacking right" do
      let(:destination_tile) { Tile.new('C3', destination_piece) }

      context "when the tile is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can't attack" do
          ok = move.call

          expect(ok).to be_falsey
          expect(start_tile).to be_occupied
          expect(destination_tile.piece).to eq destination_piece
        end
      end

      context "when the tile is occupied" do
        let(:destination_piece) { Pieces::King.new }

        it "eats the piece" do
          ok = move.call

          expect(ok).to be_truthy
          expect(start_tile).not_to be_occupied
          expect(destination_tile.piece).to eq(start_piece)
        end
      end
    end

    context "a pawn moving one forward" do
      let(:destination_tile) { Tile.new('B3', destination_piece) }

      context "when the tile is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can move" do
          ok = move.call

          expect(ok).to be_truthy
          expect(start_tile).not_to be_occupied
          expect(destination_tile.piece).to eq(start_piece)
        end
      end

      context "when the tile is occupied" do
        let(:destination_piece) { Pieces::Pawn.new }

        it "can't move" do
          ok = move.call

          expect(ok).to be_falsey
          expect(start_tile.piece).to eq(start_piece)
          expect(destination_tile).to be_occupied
        end
      end
    end
  end
end
