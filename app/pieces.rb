# No dependencies
#
# The pieces that sit in the Tile of the Boad waiting to be in a Move
module Pieces
  class Abstract
    def initialize(description = object_id)
      @description = description
    end

    attr_reader :description

    def present?
      true
    end
  end

  class Pawn < Abstract; end
  class Rook < Abstract; end
  class Knight < Abstract; end
  class Bishop < Abstract; end
  class Queen < Abstract; end
  class King < Abstract; end

  class Null < Abstract
    def ==(other_piece)
      !other_piece.present?
    end

    def present?
      false
    end
  end
end
