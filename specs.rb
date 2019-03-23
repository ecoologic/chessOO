require 'pry'
require 'rspec'

require_relative 'chess'

RSpec.describe Move do
  subject(:move) { described_class.new(start_tile, destination_tile) }

  let(:start_tile) { Tile.new(1, 1, start_piece) }
  let(:start_piece) { Pieces::Pawn.new }

  describe '#call' do
    context "a pawn moving off the board" do
      let(:start_tile) { Tile.new(4, 7, start_piece) }
      let(:destination_tile) { Tile.new(4, 8, destination_piece) }
      let(:destination_piece) { Pieces::Null.new }

      it "can't move" do
        ok = move.call

        expect(ok).to be_falsey
        expect(start_tile).to be_occupied
        expect(start_tile.piece).to eq start_piece
      end
    end

    context "a pawn attacking right" do
      let(:destination_tile) { Tile.new(2, 2, destination_piece) }

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
      let(:destination_tile) { Tile.new(1, 2, destination_piece) }

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

##############################################################################

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe '.initial_disposition' do
    let(:disposition) { described_class.initial_disposition }
    let(:first_tile) { disposition.first.first }
    let(:last_tile) { disposition.last.last }

    it "sets the tiles coordinates" do
      expect([first_tile.x, first_tile.y]).to eq [0, 0]
      expect([disposition.first.last.x, disposition.first.last.y]).to eq [7, 0]
      expect([disposition.last.first.x, disposition.last.first.y]).to eq [0, 7]
      expect([last_tile.x, last_tile.y]).to eq [7, 7]
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
    let!(:start_piece) { board.tile_at(start_position).piece }
    let(:start_position) { 'G2' }
    let(:destination_position) { 'G3' }

    it "raises an error if you try to move an empty piece" do
      expect { board.move('E5', 'E6') }.to raise_error(ArgumentError)
    end

    it "moves the piece on the board" do
      ok = board.move(start_position, destination_position)

      expect(ok).not_to be_nil
      expect(board.tile_at(start_position)).not_to be_occupied
      expect(board.tile_at(destination_position).piece).to eq start_piece
    end

    it "takes the pawn to kill the king" do
      start_pawn = board.tile_at('B7').piece

      expect(board.move('B7', 'B6')).not_to be_nil
      expect(board.move('B6', 'B5')).not_to be_nil
      expect(board.move('B5', 'B4')).not_to be_nil
      expect(board.move('B4', 'B3')).not_to be_nil
      expect(board.move('B3', 'C2')).not_to be_nil # Eat the pawn # TODO: not happening
      expect(board.move('C2', 'D1')).not_to be_nil # Kill the king

      expect(board.tile_at('D1').piece).to eq start_pawn
    end

    it "takes the pawn to kill the king, but dies before" do
      attacker = board.tile_at('C2').piece

      expect(board.move('D7', 'D6')).to be_truthy
      expect(board.move('D6', 'D5')).to be_truthy
      expect(board.move('D5', 'D4')).to be_truthy
      expect(board.move('D4', 'D3')).to be_truthy

      expect(board.move('D3', 'D2')).to be_falsey
      expect(board.move('C2', 'D3')).to be_truthy # The opponent eats

      expect(board.tile_at('D3').piece).to eq attacker
      expect(board.tile_at('C2')).not_to be_occupied
    end
  end

  describe '#tile_at' do
    subject :board do
      described_class.new [
        [Tile.new(0, 0, piece), '01'],
        %w[10 11]
      ]
    end

    let(:piece) { :x }

    it "finds the piece" do
      expect(board.tile_at('a1').piece).to eq piece
    end
  end
end
