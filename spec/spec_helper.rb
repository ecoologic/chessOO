require 'pry'
require 'rspec'

require_relative '../application'

RSpec.shared_examples :lets do |_parameter|
  let(:board) { Board.new }
  let(:disposition) { Board.initial_disposition }
  let(:row_board) { Board.new([disposition.first]) }
  let(:column_board) { Board.new(disposition.map { |r| [r.first] }) }

  let(:start_tile) { Tile.new(start_position_value, start_piece) }
  let(:destination_tile) { Tile.new(destination_position_value, destination_piece) }

  let(:move) { Move.new(start_tile, destination_tile) }
  let(:valid_move) { Move.new(start_tile, valid_destination_tile) }
  let(:invalid_move) { Move.new(start_tile, invalid_destination_tile) }

  let(:start_piece) { Pieces::Pawn.new }
  let(:destination_piece) { Pieces::Null.new }
end
