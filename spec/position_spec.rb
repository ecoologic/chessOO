require_relative 'spec_helper'

RSpec.describe Position do
  describe '.from_coordinates' do
    it "converts coordinates into position" do
      expect(described_class.from_coordinates([0, 0]).to_s).to eq 'A1'
      expect(described_class.from_coordinates([1, 2]).to_s).to eq 'B3'
      expect(described_class.from_coordinates([7, 7]).to_s).to eq 'H8'
    end
  end
end

RSpec.describe Position::Delta do
  describe '#all_between' do
    it "sees G7 from B2" do
      expect(described_class.new(Position.new('B2'), Position.new('G7')).all_between)
        .to eq %w[C3 D4 E5 F6].map { |p| Position.new(p) }
    end
  end
end
