# Moves -> [Move, Tile]
module Moves
  module Common
    def move_of_one?
      [0, delta_x.abs, delta_y.abs, 1].minmax == [0, 1]
    end
  end

  class Abstract
    def initialize(move)
      @move = move
    end

    def call
      if move.standing? || !move.in_board?
        false
      elsif move.destination_tile.occupied?
        valid_attack?
      else
        valid_move?
      end
    end

    private

    attr_reader :move

    def valid_move?
      raise NotImplementedError
    end

    def valid_attack?
      valid_move?
    end

    def first_occupied_tile
      move.destination_tile # FIXME: requires board instance var
    end

    # TODO: delta_coordinates
    def delta_x
      move.delta_coordinates.x
    end

    def delta_y
      move.delta_coordinates.y
    end
  end

  class Null
    def initialize(_move); end
    def call; false; end
  end

  # NOTE: position.abs -> workaround while we don't have black/white player
  class Pawn < Moves::Abstract
    def valid_move?
      delta_x.zero? && delta_y.abs == 1
    end

    def valid_attack?
      delta_x.abs == 1 && delta_y.abs == 1
    end
  end

  class Moves::Tower < Moves::Abstract; end

  class Knight < Moves::Abstract
    def valid_move?
      # OR move.delta_coordinates.coordinates.sort.map(&:abs) == [1, 2]
      delta_x.abs == 2 && delta_y == 1 ||
        delta_x.abs == 1 && delta_y.abs == 2
    end
  end

  class Bishop < Moves::Abstract
    def valid_move?
      delta_x.abs == delta_y.abs &&
        first_occupied_tile == move.destination_tile
    end
  end

  class Moves::Queen < Moves::Abstract
    include Common

    def valid_move?
      move_of_one?
    end
  end

  class Moves::King < Moves::Abstract
    include Common

    def valid_move?
      move_of_one?
    end
  end
end
