require 'spec_helper'

RSpec.describe Board do
  include_examples :lets

  subject(:board) { described_class.new }

  describe '.initial_disposition' do
    let(:last_tile) { disposition.last.last }

    let :first_row do
      [
        Pieces::Tower,
        Pieces::Knight,
        Pieces::Bishop,
        Pieces::Queen,
        Pieces::King,
        Pieces::Bishop,
        Pieces::Knight,
        Pieces::Tower
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

    let(:a1) { Tile.new('A1') }
    let(:a2) { Tile.new('A2') }
    let(:b1) { Tile.new('B1') }
    let(:b2) { Tile.new('B2') }

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
    subject :board do
      described_class.new [
                            [Tile.new('A1', piece), 'A2'],
                            %w[B1 B2]
                          ]
    end

    let(:piece) { :x }

    it "finds the piece" do
      expect(board.tile_at('A1').piece).to eq piece
    end
  end

  describe '#pieces_by_class' do
    subject :board do
      described_class.new [
                            [Tile.new('A1', Pieces::King.new),
                             Tile.new('A2')]
                          ]
    end

    it "is one where there is only one king" do
      expect(board.pieces_by_class(Pieces::King).count).to be 1
    end
  end

  describe '#to_s' do
    it "is 11 lines long" do
      expect(Board.new.to_s.lines.size).to eq 11
    end
  end
end
