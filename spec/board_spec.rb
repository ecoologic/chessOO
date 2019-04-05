require 'spec_helper'

RSpec.describe Board do
  include_examples :lets

  subject(:board) { described_class.new }

  describe '.initial_disposition' do
    let(:last_tile) { disposition.last.last }

    let :first_row do
      [
        Pieces::Rook,
        Pieces::Knight,
        Pieces::Bishop,
        Pieces::Queen,
        Pieces::King,
        Pieces::Bishop,
        Pieces::Knight,
        Pieces::Rook
      ]
    end

    it "sets the tiles coordinates" do
      expect(disposition.first.first.position.to_s).to eq 'A1'
      expect(disposition.first.last.position.to_s).to eq 'H1'
      expect(disposition.last.first.position.to_s).to eq 'A8'
      expect(disposition.last.last.position.to_s).to eq 'H8'
    end

    it "fills the first row with the big pieces" do
      expect(disposition.first.map { |t| t.piece.class })
        .to eq first_row
      expect(disposition.last.map { |t| t.piece.class })
        .to eq first_row
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

  describe '#include?' do
    example_group :lets

    let(:a1) { board.tile_at('A1') }
    let(:a2) { board.tile_at('A2') }
    let(:b1) { board.tile_at('B1') }
    let(:b2) { board.tile_at('B2') }

    it "is true only for the position values of the row (x, letters)" do
      expect(row_board.include?('A1')).to be true
      expect(row_board.include?('A2')).to be false
      expect(row_board.include?('B1')).to be true
      expect(row_board.include?('B2')).to be false
    end

    it "is true only for the position values of the column (y, numbers)" do
      expect(column_board.include?('A1')).to be true
      expect(column_board.include?('A2')).to be true
      expect(column_board.include?('B1')).to be false
      expect(column_board.include?('B2')).to be false
    end
  end

  describe '#tile_at' do
    it "finds the pieces" do
      expect(board.tile_at('E1').piece.class).to eq Pieces::King
    end
  end

  describe '#pieces_by_class' do
    subject :board do
      described_class.new [
                            [Board::Tile.new([0, 0], Pieces::King),
                             Board::Tile.new([1, 0])]
                          ]
    end

    it "is one where there is only one king" do
      expect(board.pieces_by_class(Pieces::King).count).to be 1
    end
  end
end

RSpec.describe Board::Tile do
  describe '==' do
    it "returns true when two tiles have the same position" do
      expect(described_class.new([2, 3])).to eq(described_class.new([2, 3]))
      expect(described_class.new([2, 3])).not_to eq(described_class.new([3, 2]))
    end
  end
end
