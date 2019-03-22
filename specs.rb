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

##############################################################################

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe '.initial_disposition' do
    let(:disposition) { described_class.initial_disposition }
    let(:first_cell) { disposition.first.first }
    let(:last_cell) { disposition.last.last }

    it "sets the cells coordinates" do
      expect([first_cell.x, first_cell.y]).to eq [0, 0]
      expect([disposition.first.last.x, disposition.first.last.y]).to eq [7, 0]
      expect([disposition.last.first.x, disposition.last.first.y]).to eq [0, 7]
      expect([last_cell.x, last_cell.y]).to eq [7, 7]
    end

    it "puts pawns on the second and second last row" do
      expect(disposition[1].map { |c| c.piece.class }.uniq).to eq [Pieces::Pawn]
      expect(disposition[6].map { |c| c.piece.class }.uniq).to eq [Pieces::Pawn]
    end

    it "puts nothing on the middle rows" do
      expect(disposition[2].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
      expect(disposition[3].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
      expect(disposition[4].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
      expect(disposition[5].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
    end
  end

  describe '#move' do
    let!(:start_piece) { board.cell_at(start_position).piece }
    let(:start_position) { 'G2' }
    let(:destination_position) { 'G3' }

    it "raises an error if you try to move an empty piece" do
      expect { board.move('E5', 'E6') }.to raise_error(ArgumentError)
    end

    it "moves the piece on the board" do
      ok = board.move(start_position, destination_position)

      expect(ok).not_to be_nil
      expect(board.cell_at(start_position)).not_to be_occupied
      expect(board.cell_at(destination_position).piece).to eq start_piece
    end
  end

  describe '#cell_at'
end
