require 'pry'
require_relative 'chess'
require 'rspec'

RSpec.describe Move do
  subject(:move) { described_class.new(start_cell, destination_cell) }

  let(:start_cell) { Cell.new(1, 1, start_piece) }
  let(:start_piece) { Pieces::Pawn.new }

  describe '#call' do
    context "a pawn attacking off the board" do
      let(:destination_cell) { Cell.new(0, 2, destination_piece) }
      let(:destination_piece) { Pieces::Pawn.new }

      it "can't move" do
        ok = move.call

        expect(ok).to be_falsey
        expect(start_cell).to be_occupied
        expect(start_cell.piece).to eq start_piece
      end
    end

    context "a pawn attacking right" do
      let(:destination_cell) { Cell.new(2, 2, destination_piece) }

      context "when the cell is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can't attack" do
          ok = move.call

          expect(ok).to be_falsey
          expect(start_cell).to be_occupied
          expect(destination_cell.piece).to eq destination_piece
        end
      end

      context "when the cell is occupied" do
        let(:destination_piece) { Pieces::King.new }

        it "eats the piece" do
          ok = move.call

          expect(ok).to be_truthy
          expect(start_cell).not_to be_occupied
          expect(destination_cell.piece).to eq(start_piece)
        end
      end
    end

    context "a pawn moving one forward" do
      let(:destination_cell) { Cell.new(1, 2, destination_piece) }

      context "when the cell is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can move" do
          ok = move.call

          expect(ok).to be_truthy
          expect(start_cell).not_to be_occupied
          expect(destination_cell.piece).to eq(start_piece)
        end
      end

      context "when the cell is occupied" do
        let(:destination_piece) { Pieces::Pawn.new }

        it "can't move" do
          ok = move.call

          expect(ok).to be_falsey
          expect(start_cell.piece).to eq(start_piece)
          expect(destination_cell).to be_occupied
        end
      end
    end

    context "a pawn moving two forward from starting position" do
      context "when the corridor is free"
      context "when the corridor is taken"
    end

    context "a pawn moving two forward from advanced position" do
    end
  end
end
