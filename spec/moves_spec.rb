require_relative 'spec_helper'

RSpec.describe Moves::Tower do
  include_examples :lets

  let(:start_tile) { board.tile_at('A1') }
  let(:valid_destination_tile) { Tile.new('A5') }
  let(:invalid_destination_tile) { Tile.new('B7') }

  describe '#valid?' do
    it "is true when moved along empty axes" do
      board.tile_at('A2').piece = Pieces::Null.new
      expect(described_class.new(valid_move)).to be_valid
    end

    it "is false when moved 2 ahead" do
      expect(described_class.new(invalid_move)).not_to be_valid
    end
  end
end

RSpec.describe Moves::Knight do
  include_examples :lets

  let(:start_tile) { Tile.new('E4', Pieces::Knight.new) }
  let(:valid_destination_tile) { Tile.new('G5') }
  let(:invalid_destination_tile) { Tile.new('E3') }

  describe '#valid?' do
    it "is valid when you move one up and two left" do
      allow(valid_move).to receive(:in_board?).and_return(true)

      expect(described_class.new(valid_move)).to be_valid
    end

    it "is invalid when try to move like a pawn" do
      allow(valid_move).to receive(:in_board?).and_return(true)

      expect(described_class.new(invalid_move)).not_to be_valid
    end
  end
end

RSpec.describe Moves::Queen do
  include_examples :lets

  let(:start_tile) { Tile.new('E5', Pieces::Queen.new) }
  let(:valid_destination_tile) { Tile.new('F6') }
  let(:invalid_destination_tile) { Tile.new('E7') }

  describe '#valid?' do
    it "is true when moved one diagonal" do
      expect(described_class.new(valid_move)).to be_valid
    end

    xit "is true when moved 2 ahead" do
      expect(described_class.new(invalid_move)).to be_valid
    end
  end
end

RSpec.describe Moves::King do
  include_examples :lets

  let(:start_tile) { Tile.new('E5', Pieces::King.new) }
  let(:valid_destination_tile) { Tile.new('F6') }
  let(:invalid_destination_tile) { Tile.new('E7') }

  describe '#valid?' do
    it "is true when moved one diagonal" do
      expect(described_class.new(valid_move)).to be_valid
    end

    it "is false when moved 2 ahead" do
      expect(described_class.new(invalid_move)).not_to be_valid
    end
  end
end
