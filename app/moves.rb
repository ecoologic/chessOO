# Moves->Move:
# Moves->Tile:
# Moves->Position:
#
# Describes HOW every piece move
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

  class Pawn < Moves::Abstract
    private

    def valid_move?
      move.delta.one_forward?
    end

    def valid_attack?
      move.delta.one_up_diagonal? # TODO: one_forward_diagonal?
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
      move.delta.l_shape?
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
