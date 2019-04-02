require 'spec_helper'

RSpec.describe Tile do
  describe '==' do
    it "returns true when two tiles have the same position" do
      expect(described_class.new('A1')).to eq(described_class.new('A1'))
    end
  end
end
