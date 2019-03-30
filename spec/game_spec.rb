require 'spec_helper'

RSpec.describe Game do
  include_examples :lets

  subject(:game) { described_class.new(board) }

  describe '#move' do
    let!(:start_piece) { board.tile_at(start_position_value).piece }

    let(:start_position_value) { 'G2' }
    let(:destination_position_value) { 'G3' }

    it "doesn't move off the board" do
      expect(game.move('E8', 'E9')).to be_nil
    end

    it "doesn't move when the game is over" do
      game.send(:board).tile_at('E1').piece = Pieces::Null

      expect(game.move('A1', 'A2')).to be_nil
    end

    it "raises an error if you try to move an empty piece" do
      expect { game.move('E5', 'E6') }.to raise_error(RuntimeError)
    end

    it "moves the piece on the board" do
      ok = game.move(start_position_value, destination_position_value)

      expect(ok).not_to be_nil
      expect(board.tile_at(start_position_value)).not_to be_occupied
      expect(board.tile_at(destination_position_value).piece).to eq start_piece
    end

    it "takes the pawn to kill the king" do
      start_pawn = board.tile_at('C7').piece

      expect(game.move('C7', 'C6')).not_to be_nil
      expect(game.move('C6', 'C5')).not_to be_nil
      expect(game.move('C5', 'C4')).not_to be_nil
      expect(game.move('C4', 'C3')).not_to be_nil
      expect(game.move('C3', 'D2')).not_to be_nil # Eat the pawn # TODO: not happening
      expect(game).to be_on
      expect(game.move('D2', 'E1')).not_to be_nil # Kill the king
      expect(game).not_to be_on
      expect(board.tile_at('E1').piece).to eq start_pawn
    end

    it "takes the pawn to kill the king, but dies before" do
      attacker = board.tile_at('C2').piece

      expect(game.move('D7', 'D6')).to be_truthy
      expect(game.move('D6', 'D5')).to be_truthy
      expect(game.move('D5', 'D4')).to be_truthy
      expect(game.move('D4', 'D3')).to be_truthy

      expect(game.move('D3', 'D2')).to be_falsey
      expect(game.move('C2', 'D3')).to be_truthy # The opponent eats

      expect(board.tile_at('D3').piece).to eq attacker
      expect(board.tile_at('C2')).not_to be_occupied
    end

    it "kills the king with the bishop" do
      expect(game.move('G2', 'G3')).to be_truthy # Move the white pawn
      expect(game.move('F1', 'G2')).to be_truthy # Move the white bishop
      expect(game.move('G2', 'C6')).to be_truthy # Move the bishop again
      # TODO: expect(game.move('C6', 'E8')).to be_falsey # Attack the black King, Pawn in the way

      expect(game.move('D7', 'D6')).to be_truthy # Move the black pawn away
      expect(game).to be_on
      expect(game.move('C6', 'E8')).to be_truthy # Attack the black King
      expect(game).not_to be_on
    end

    it "kills the king with a knight" do
      expect(game.move('B1', 'C3')).to be_truthy # Move the white pawn
      expect(game).to be_on
      expect(game.move('C3', 'D5')).to be_truthy # Move the white pawn
      expect(game).to be_on

      expect(game.move('D5', 'C7')).to be_truthy
      expect(game).to be_on

      expect(game.move('C7', 'E8')).to be_truthy # Kill the king
      expect(game).not_to be_on
    end
  end
end
