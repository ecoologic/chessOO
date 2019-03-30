require_relative 'spec_helper'

RSpec.describe Position do
  describe '.from_coordinates' do
    it "converts coordinates into position" do
      expect(described_class.from_coordinates([0, 0]).to_s).to eq 'A1'
      expect(described_class.from_coordinates([1, 2]).to_s).to eq 'B3'
      expect(described_class.from_coordinates([7, 7]).to_s).to eq 'H8'
    end
  end

  describe '#all_between' do
    it "sees G7 from B2" do
      expect(described_class.new('B2').all_between(described_class.new('G7')))
        .to eq %w[C3 D4 E5 F6].map { |p| described_class.new(p) }
    end
  end
end
