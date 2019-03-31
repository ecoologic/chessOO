require 'spec_helper'
RSpec.describe Hand do
  include_examples :lets

  subject(:hand) { described_class.new(Move.new(board, start_tile, destination_tile)) }

  let(:start_position_value) { 'B2' }
  let(:destination_position_value) { 'E9' }

  describe '#call' do
    context "a pawn attacking right" do
      let(:destination_tile) { Tile.new('C3', destination_piece) }

      context "when the tile is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can't attack" do
          ok = hand.call

          expect(ok).to be_falsey
          expect(start_tile).to be_occupied
          expect(destination_tile.piece).to eq destination_piece
        end
      end

      context "when the tile is occupied" do
        let(:destination_piece) { Pieces::King.new }

        it "eats the piece" do
          ok = hand.call

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

        it "can hand" do
          ok = hand.call

          expect(ok).to be_truthy
          expect(start_tile).not_to be_occupied
          expect(destination_tile.piece).to eq(start_piece)
        end
      end

      context "when the tile is occupied" do
        let(:destination_piece) { Pieces::Pawn.new }

        it "can't hand" do
          ok = hand.call

          expect(ok).to be_falsey
          expect(start_tile.piece).to eq(start_piece)
          expect(destination_tile).to be_occupied
        end
      end
    end
  end
end
