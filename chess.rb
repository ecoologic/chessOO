# Moves -> [Move, Board, Tile]
module Moves
  class Null
    def initialize(_move); end
    def call; false; end
  end

  # TODO: Abstract
  class Pawn
    def initialize(move)
      @move = move
    end

    def call
      if !Board.include?(move.destination_tile)
        false
      elsif move.destination_tile.occupied?
        valid_attack?
      else
        valid_move?
      end
    end

    private

    attr_reader :move

    # NOTE: delta_y.abs -> workaround while we don't have colors
    def valid_move?
      delta_x.zero? && delta_y.abs == 1
    end

    # NOTE: delta_y.abs -> workaround while we don't have colors
    def valid_attack?
      delta_x.abs == 1 && delta_y.abs == 1
    end

    def delta_x
      move.start_tile.coordinates_delta(move.destination_tile).first
    end

    def delta_y
      move.start_tile.coordinates_delta(move.destination_tile).last
    end
  end
end

# Move -> [Moves, Tile, Pieces]
class Move
  RULES = {
    "Pieces::Null" => Moves::Null,
    "Pieces::Pawn" => Moves::Pawn
  } # TODO: not strings

  def initialize(start_tile, destination_tile)
    @start_tile, @destination_tile = start_tile, destination_tile
    @moving_piece = start_tile.piece
    raise ArgumentError, "Can't move an empty tile" unless start_tile.occupied?
  end

  attr_reader :start_tile, :destination_tile, :moving_piece

  def inspect
    "<#{start_tile} -> #{destination_tile}>"
  end

  def call
    return unless can_move?

    start_tile.piece = Pieces::Null.new
    destination_tile.piece = moving_piece
  end

  private

  def can_move?
    RULES[moving_piece.class.to_s].new(self).call
  end
end

# Moves
##############################################################################
# Board and Tile

# Board -> [Move, Tile, Pieces]
# Borders starting from 0 to 7
# TODO: board instance
class Board
  def self.include?(tile)
    ('A'..'G').to_a.include?(tile.letter) &&
      (1..8).to_a.include?(tile.number)
  end

  def self.initial_disposition
    _, p, k = Pieces::Null, Pieces::Pawn, Pieces::King
    [ # A B  C  D  E  F  G  H
      [p, p, p, k, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 0], p) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 1], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 2], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 3], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 4], p) },
      [_, _, _, _, _, _, _, _].each_with_index.map { |p, x| tile_for([x, 5], p) },
      [p, p, p, p, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 6], p) },
      [p, p, p, k, p, p, p, p].each_with_index.map { |p, x| tile_for([x, 7], p) },
    ]
  end

  def self.tile_for(coordinates, piece_class)
    Tile.new(position_for(coordinates), piece_class.new)
  end

  # E.g.: [4, 5] -> 'E6'
  def self.position_for(coordinates)
    x, y = coordinates
    letter_x = ('A'.bytes.first + x).chr
    number_y = y + 1

    "#{letter_x}#{number_y}"
  end

  # E.g.: 'E5' -> [4, 4]
  def self.coordinates_for(position)
    letter_x, letter_y = position.chars
    x = letter_x.upcase.bytes.first - 'A'.bytes.first
    y = letter_y.to_i - 1 # Classic -1: index starting at 0

    [x, y] # TODO: raise unless include
  end

  def initialize(matrix = self.class.initial_disposition)
    @matrix = matrix
  end

  def move(start_position, destination_position)
    Move.new(
      tile_at(start_position),
      tile_at(destination_position)
    ).call
  end

  def tile_at(position)
    x, y = self.class.coordinates_for(position)
    row = matrix[y]

    row[x]
  end

  private

  # NOTE: Access is matrix[y][x] (first access the row)
  attr_reader :matrix
end

# Tile -> [Piece]
class Tile
  def initialize(position, piece = Pieces::Null.new)
    @position, @piece = position, piece
  end

  attr_reader :position
  attr_accessor :piece

  def inspect
    "#<#{self.class}:#{position}>"
  end

  def ==(other_tile)
    other_tile.position == position
  end

  def occupied?
    piece.present?
  end

  def coordinates_delta(other_tile)
    x, y = Board.coordinates_for(position) # TODO: dep direction
    other_x, other_y = Board.coordinates_for(other_tile.position)

    [(other_x - x), (other_y - y)]
  end

  # TODO: tmp

  def letter
    position.chars.first
  end

  def number
    position.chars.last.to_i
  end
end

# Board and Tile
##############################################################################
# Pieces

# Pieces -> [Piece]
module Pieces
  class Abstract
    def initialize
      @id = rand # TODO: optional naming
    end

    attr_reader :id

    def inspect
      "#<#{self.class}:#{id}>"
    end

    def ==(other_piece)
      other_piece.id == id
    end

    def present?
      true
    end
  end

  class Pawn < Abstract; end
  class King < Abstract; end

  class Null < Abstract
    def inspect
      "#<Pieces::Null>"
    end

    def ==(other_piece)
      !other_piece.present?
    end

    def present?
      false
    end
  end
end

require 'pry'
require 'rspec'

# require_relative 'chess'

RSpec.describe Move do
  subject(:move) { described_class.new(start_tile, destination_tile) }

  let(:start_tile) { Tile.new('B2', start_piece) }
  let(:start_piece) { Pieces::Pawn.new }

  describe '#call' do
    context "a pawn moving off the board" do
      let(:start_tile) { Tile.new('E8', start_piece) }
      let(:destination_tile) { Tile.new('E9', destination_piece) }
      let(:destination_piece) { Pieces::Null.new }

      it "can't move" do
        ok = move.call

        expect(ok).to be_falsey
        expect(start_tile).to be_occupied
        expect(start_tile.piece).to eq start_piece
      end
    end

    context "a pawn attacking right" do
      let(:destination_tile) { Tile.new('C3', destination_piece) }

      context "when the tile is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can't attack" do
          ok = move.call

          expect(ok).to be_falsey
          expect(start_tile).to be_occupied
          expect(destination_tile.piece).to eq destination_piece
        end
      end

      context "when the tile is occupied" do
        let(:destination_piece) { Pieces::King.new }

        it "eats the piece" do
          ok = move.call

          expect(ok).to be_truthy
          expect(start_tile).not_to be_occupied
          expect(destination_tile.piece).to eq(start_piece)
        end
      end
    end

    context "a pawn moving one forward" do
      let(:destination_tile) { Tile.new('B3', destination_piece) }

      context "when the tile is empty" do
        let(:destination_piece) { Pieces::Null.new }

        it "can move" do
          ok = move.call

          expect(ok).to be_truthy
          expect(start_tile).not_to be_occupied
          expect(destination_tile.piece).to eq(start_piece)
        end
      end

      context "when the tile is occupied" do
        let(:destination_piece) { Pieces::Pawn.new }

        it "can't move" do
          ok = move.call

          expect(ok).to be_falsey
          expect(start_tile.piece).to eq(start_piece)
          expect(destination_tile).to be_occupied
        end
      end
    end
  end
end

##############################################################################

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe '.initial_disposition' do
    let(:disposition) { described_class.initial_disposition }
    let(:last_tile) { disposition.last.last }

    it "sets the tiles coordinates" do
      expect(disposition.first.first.position).to eq 'A1'
      expect(disposition.first.last.position).to eq 'H1'
      expect(disposition.last.first.position).to eq 'A8'
      expect(disposition.last.last.position).to eq 'H8'
    end

    it "puts pawns on the second and second last row" do
      expect(disposition[1].map { |c| c.piece.class }.uniq).to eq [Pieces::Pawn]
      expect(disposition[6].map { |c| c.piece.class }.uniq).to eq [Pieces::Pawn]
    end

    it "puts nothing on the middle rows" do
      expect(disposition[2].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
      expect(disposition[3].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
      expect(disposition[4].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
      expect(disposition[5].map { |c| c.piece.class }.uniq).to eq [Pieces::Null]
    end
  end

  describe '.position_for' do
    it "converts coordinates into position" do
      expect(described_class.position_for([0, 0])).to eq 'A1'
      expect(described_class.position_for([1, 2])).to eq 'B3'
      expect(described_class.position_for([7, 7])).to eq 'H8'
    end
  end

  describe '#move' do
    let!(:start_piece) { board.tile_at(start_position).piece }
    let(:start_position) { 'G2' }
    let(:destination_position) { 'G3' }

    it "raises an error if you try to move an empty piece" do
      expect { board.move('E5', 'E6') }.to raise_error(ArgumentError)
    end

    it "moves the piece on the board" do
      ok = board.move(start_position, destination_position)

      expect(ok).not_to be_nil
      expect(board.tile_at(start_position)).not_to be_occupied
      expect(board.tile_at(destination_position).piece).to eq start_piece
    end

    it "takes the pawn to kill the king" do
      start_pawn = board.tile_at('B7').piece

      expect(board.move('B7', 'B6')).not_to be_nil
      expect(board.move('B6', 'B5')).not_to be_nil
      expect(board.move('B5', 'B4')).not_to be_nil
      expect(board.move('B4', 'B3')).not_to be_nil
      expect(board.move('B3', 'C2')).not_to be_nil # Eat the pawn # TODO: not happening
      expect(board.move('C2', 'D1')).not_to be_nil # Kill the king

      expect(board.tile_at('D1').piece).to eq start_pawn
    end

    it "takes the pawn to kill the king, but dies before" do
      attacker = board.tile_at('C2').piece

      expect(board.move('D7', 'D6')).to be_truthy
      expect(board.move('D6', 'D5')).to be_truthy
      expect(board.move('D5', 'D4')).to be_truthy
      expect(board.move('D4', 'D3')).to be_truthy

      expect(board.move('D3', 'D2')).to be_falsey
      expect(board.move('C2', 'D3')).to be_truthy # The opponent eats

      expect(board.tile_at('D3').piece).to eq attacker
      expect(board.tile_at('C2')).not_to be_occupied
    end
  end

  describe '#tile_at' do
    subject :board do
      described_class.new [
                            [Tile.new('A1', piece), 'A2'],
                            %w[B1 B2]
                          ]
    end

    let(:piece) { :x }

    it "finds the piece" do
      expect(board.tile_at('A1').piece).to eq piece
    end
  end
end
