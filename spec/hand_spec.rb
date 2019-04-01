require 'spec_helper'
RSpec.describe Hand do
  include_examples :lets

  subject :hand do
    described_class.new(Move.new(board,
                                 start_position_value,
                                 destination_position_value))
  end

  let(:start_position_value) { 'B2' }
  let(:destination_position_value) { 'E9' }
  let!(:start_piece) { board.tile_at(start_position_value).piece }

  describe '#call' do
    context "a pawn attacking right" do
      let(:destination_position_value) { 'C3' }

      context "when the tile is empty" do
        it "can't attack" do
          board.tile_at(destination_position_value).piece = Pieces::Null.new

          ok = hand.call

          expect(ok).to be_falsey
          expect(board.tile_at(start_position_value)).to be_occupied
          expect(board.tile_at(destination_position_value).piece).to eq Pieces::Null.new
        end
      end

      context "when the tile is occupied" do
        it "eats the piece" do
          board.tile_at(destination_position_value).piece = Pieces::King.new

          ok = hand.call

          expect(ok).to be_truthy
          expect(board.tile_at(start_position_value)).not_to be_occupied
          expect(board.tile_at(destination_position_value).piece).to eq(start_piece)
        end
      end
    end

    context "a pawn moving one forward" do
      let(:destination_position_value) { 'B3' }

      context "when the tile is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can move" do
          ok = hand.call

          expect(ok).to be_truthy
          expect(board.tile_at(start_position_value)).not_to be_occupied
          expect(board.tile_at(destination_position_value).piece).to eq(start_piece)
        end
      end

      context "when the tile is occupied" do
        it "can't move" do
          board.tile_at(destination_position_value).piece = Pieces::Pawn.new

          ok = hand.call

          expect(ok).to be_falsey
          expect(board.tile_at(start_position_value).piece).to eq(start_piece)
          expect(board.tile_at(destination_position_value)).to be_occupied
        end
      end
    end
  end
end
