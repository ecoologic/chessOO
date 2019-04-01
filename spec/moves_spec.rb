require_relative 'spec_helper'

RSpec.describe Moves::Rook do
  include_examples :lets

  let(:start_position_value) { 'A1' }
  let(:valid_destination_position_value) { 'A5' }
  let(:invalid_destination_position_value) { 'B7' }

  describe '#valid?' do
    it "is true when moved along empty axes" do
      board.tile_at('A2').piece = Pieces::Null.new

      expect(described_class.new(valid_move)).to be_valid
    end

    it "is false when the move is invalid" do
      expect(described_class.new(invalid_move)).not_to be_valid
    end
  end
end

RSpec.describe Moves::Knight do
  include_examples :lets

  let(:start_position_value) { 'E4' }
  let(:valid_destination_position_value) { 'G5' }
  let(:invalid_destination_position_value) { 'E3' }

  describe '#valid?' do
    it "is valid when you move one up and two left" do
      board.tile_at(start_position_value).piece = Pieces::Knight.new

      expect(described_class.new(valid_move)).to be_valid
    end

    it "is invalid when try to move like a pawn" do
      board.tile_at(start_position_value).piece = Pieces::Knight.new

      expect(described_class.new(invalid_move)).not_to be_valid
    end
  end
end

RSpec.describe Moves::Queen do
  include_examples :lets

  let(:start_position_value) { 'E5' }
  let(:valid_destination_position_value) { 'F6' }
  let(:invalid_destination_position_value) { 'E7' }

  describe '#valid?' do
    it "is true when moved one diagonal" do
      board.tile_at(start_position_value).piece = Pieces::Queen.new

      expect(described_class.new(valid_move)).to be_valid
    end

    xit "is true when moved 2 ahead" do
      expect(described_class.new(invalid_move)).to be_valid
    end
  end
end

RSpec.describe Moves::King do
  include_examples :lets

  let(:start_position_value) { 'E5' }
  let(:valid_destination_position_value) { 'F6' }
  let(:invalid_destination_position_value) { 'E7' }

  describe '#valid?' do
    it "is true when moved one diagonal" do
      board.tile_at(start_position_value).piece = Pieces::King.new

      expect(described_class.new(valid_move)).to be_valid
    end

    it "is false when moved 2 ahead" do
      board.tile_at(start_position_value).piece = Pieces::King.new

      expect(described_class.new(invalid_move)).not_to be_valid
    end
  end
end
