require 'pry'
require_relative 'chess'
require 'rspec'

RSpec.describe Move do
  subject(:move) { described_class.new(start_cell, destination_cell) }

  let(:start_piece) { Pieces::Pawn.new }
  let(:start_cell) { Cell.new(:a, 1, start_piece) }
  let(:destination_cell) { Cell.new(:a, 2, Pieces::Pawn.new) }

  context "a pawn" do
    describe '#call' do
      it "can move one forward" do
        ok = move.call

        expect(ok).to be true
        expect(start_cell.piece).to eq Pieces::Null.new
        expect(destination_cell.piece).to eq(start_piece)
      end

      # it "can't move one forward if the cell is occupied" do
      #   result = move.call
      #
      #   expect(result).to be false
      #   expect(start_cell.piece).to eq(start_piece)
      #   expect(destination_cell.piece).to be nil
      # end
    end
  end
end
