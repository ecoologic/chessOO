# Moves -> [Move, Tile]
module Moves
  class Null
    def initialize(_move); end
    def call; false; end
  end

  class Abstract
    def initialize(move)
      @move = move
    end

    def call
      if !move.in_board?
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

    def delta_x
      move.delta_position.x
    end

    def delta_y
      move.delta_position.y
    end
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

  class Bishop < Moves::Abstract
    def valid_move?
      delta_x.abs == delta_y.abs &&
        first_occupied_tile == move.destination_tile
    end
  end
end
