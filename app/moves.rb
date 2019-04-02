# Moves->Move:
# Moves->Tile:
# Moves->Position:
module Moves
  class Abstract
    def initialize(move)
      @move = move
    end

    def valid?
      if move.standing?
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
  end

  class Null
    def initialize(_move); end
    def call; false; end
  end

  # NOTE: position.abs -> workaround while we don't have black/white player
  class Pawn < Moves::Abstract
    private

    def valid_move?
      move.delta.x.zero? && move.delta.y.abs == 1
    end

    def valid_attack?
      move.delta.x.abs == 1 && move.delta.y.abs == 1
    end
  end

  class Moves::Rook < Moves::Abstract
    private

    def valid_move?
      move.delta.one_axis? && move.free_corridor?
    end
  end

  class Knight < Moves::Abstract
    private

    def valid_move?
      [move.delta.x.abs, move.delta.y.abs].sort == [1, 2]
    end
  end

  class Bishop < Moves::Abstract
    private

    def valid_move?
      move.delta.diagonal? && move.free_corridor?
    end
  end

  class Moves::Queen < Moves::Abstract
    private

    def valid_move?
      (move.delta.one_axis? || move.delta.diagonal?) && move.free_corridor?
    end
  end

  class Moves::King < Moves::Abstract
    private

    def valid_move?
      move.delta.one_step?
    end
  end
end
