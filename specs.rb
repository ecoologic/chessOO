require 'pry'
require_relative 'chess'
require 'rspec'

RSpec.describe Move do
  subject(:move) { described_class.new(start_cell, destination_cell) }

  let(:start_cell) { Cell.new(:a, 1, start_piece) }

  describe '#call' do
    context "a pawn moving one forward" do
      let(:start_piece) { Pieces::Pawn.new }
      let(:destination_cell) { Cell.new(:a, 2, destination_piece) }

      context "when the cell is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can move" do
          moved = move.call

          expect(moved).to be true
          expect(start_cell).not_to be_occupied
          expect(destination_cell.piece).to eq(start_piece)
        end
      end

      context "when the cell is occupied" do
        let(:destination_piece) { Pieces::Pawn.new }

        it "can't move" do
          moved = move.call

          expect(moved).to be false
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
