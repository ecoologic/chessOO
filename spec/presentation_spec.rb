RSpec.describe "Presentation" do
  describe Game do
    describe '#to_s' do
      it { expect(Game.new.to_s).to eq('#<Game>') }
    end
  end

  describe Board do
    describe '#to_s' do
      it "is 11 lines long" do
        expect(Board.new.to_s.lines.size).to eq 11
      end
    end
  end

  describe Tile do
    describe '#inspect' do
      it { expect(described_class.new('A1').to_s).to eq('#<Tile:A1:__>') }
    end
  end

  describe Position do
    describe '#to_s' do
      it "is in letter number format" do
        expect(described_class.new('A1').to_s).to eq('A1')
      end
    end
  end

  describe Moves::Queen do
    describe '#inspect' do
      it { expect(described_class.new('XXX').to_s).to eq('#<Moves::Queen:"XXX">') }
    end
  end

  describe Pieces::Null do
    describe '#inspect' do
      it { expect(described_class.new.to_s).to eq('#<Pieces::Null>') }
    end
  end

  describe Pieces::Pawn do
    describe '#inspect' do
      it { expect(described_class.new('XXX').to_s).to eq('#<Pieces::Pawn:init-XXX>') }
    end
  end
end
