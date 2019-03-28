require 'spec_helper'

RSpec.describe Move do
  subject(:move) { described_class.new(start_tile, destination_tile) }

  let(:start_tile) { Tile.new('B2', start_piece) }
  let(:start_piece) { Pieces::Pawn.new }

  describe '#call' do
    context "a pawn moving off the board" do
      let(:start_tile) { Tile.new('E8', start_piece) }
      let(:destination_tile) { Tile.new('E9', destination_piece) }
      let(:destination_piece) { Pieces::Null.new }

      it "can't move" do
        ok = move.call

        expect(ok).to be_falsey
        expect(start_tile).to be_occupied
        expect(start_tile.piece).to eq start_piece
      end
    end

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
