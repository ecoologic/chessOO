require 'spec_helper'

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe '.initial_disposition' do
    let(:disposition) { described_class.initial_disposition }
    let(:last_tile) { disposition.last.last }

    it "sets the tiles coordinates" do
      expect(disposition.first.first.position_value).to eq 'A1'
      expect(disposition.first.last.position_value).to eq 'H1'
      expect(disposition.last.first.position_value).to eq 'A8'
      expect(disposition.last.last.position_value).to eq 'H8'
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
end
