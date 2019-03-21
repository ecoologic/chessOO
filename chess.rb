require 'pry'

class Chess
  def initialize
    start_cell, destination_cell = Cell.new(:a, 1), Cell.new(:a, 2)
    Move.new(start_cell, destination_cell).call
  end
end

class Move
  def initialize(start_cell, destination_cell)
    @start_cell, @destination_cell = start_cell, destination_cell
    @moving_piece = start_cell.piece
    @rank = start_cell.piece.rank
  end

  def to_s
    "[#{rank}] #{start_cell} -> #{destination_cell}"
  end

  def call
    start_cell.piece = nil
    destination_cell.piece = moving_piece
    destination_cell.piece == moving_piece
  end

  private

  attr_reader :start_cell, :destination_cell, :moving_piece
end

class Cell
  def initialize(x, y, piece = nil)
    @x, @y, @piece = x, y, piece
  end

  def to_s
    "#{x},#{y}"
  end

  attr_reader :x, :y
  attr_accessor :piece

  def ==(other_cell)
    other_cell.x == x && other_cell.y == y
  end
end

class Piece
  def initialize(rank)
    @rank = rank
    @id = "#{rank}##{rand}" # TODO: singletons
  end

  attr_reader :id, :rank

  def ==(other_piece)
    other_piece.id == id
  end
end

module Ranks
  class Pawn
  end
end

require 'rspec'

RSpec.describe Move do
  subject(:move) { described_class.new(start_cell, destination_cell) }

  let(:start_cell) { Cell.new(:a, 1, start_piece) }
  let(:destination_cell) { Cell.new(:a, 2, Piece.new(Ranks::Pawn)) }
  let(:start_piece) { Piece.new(Ranks::Pawn) }

  context "a pawn" do
    describe '#call' do
      it "can move one forward" do
        result = move.call

        expect(result).to be true
        expect(start_cell.piece).to be nil
        expect(destination_cell.piece).to eq(start_piece)
      end

      # it "can't move one forward if the cell is occupied" do
      #   result = move.call
      #
      #   expect(result).to be false
      #   expect(start_cell.piece).to eq(start_piece)
      #   expect(destination_cell.piece).to be nil
      # end
    end
  end
end
