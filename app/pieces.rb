# Pieces -> [Piece]
module Pieces
  class Abstract
    def self.to_sym
      to_s['Pieces::'.length, 2].to_sym
    end

    def initialize(description = object_id)
      @description = description
    end

    attr_reader :description

    def inspect
      %(#<#{to_sym}:piece_start=#{description}>)
    end

    def to_sym
      self.class.to_sym
    end

    def present?
      true
    end
  end

  class Pawn < Abstract; end
  class Tower < Abstract; end
  class Knight < Abstract; end
  class Bishop < Abstract; end
  class Queen < Abstract; end
  class King < Abstract; end

  class Null < Abstract
    def self.to_sym
      '__'
    end

    def ==(other_piece)
      !other_piece.present?
    end

    def present?
      false
    end
  end
end
