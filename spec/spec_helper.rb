require 'pry'
require 'rspec'

require_relative '../application'

RSpec.shared_examples :lets do |_parameter|
  # TODO: board_row, initial_disposition
  let(:board) { Board.new }
  let(:disposition) { Board.initial_disposition }
  let(:row_board) { Board.new([disposition.first]) }
  let(:column_board) { Board.new(disposition.map { |r| [r.first] }) }

  let :move do
    Move.new(board, start_position_value, destination_position_value)
  end

  let :valid_move do
    Move.new(board, start_position_value, valid_destination_position_value)
  end

  let :invalid_move do
    Move.new(board, start_position_value, invalid_destination_position_value)
  end
end
