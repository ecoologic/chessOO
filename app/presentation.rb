class Game
  def to_s; inspect; end

  def inspect
    "#<Game>"
  end
end

class Board
  #      .A .B .C .D .E .F .G .H
  # | .8 Pa Kn Bi Pa Ki Bi Kn Pa 8. |
  # | .7 Pa Pa Pa Pa Pa Pa Pa Pa 7. |
  # | .6 __ __ __ __ __ __ __ __ 6. |
  # | .5 __ __ __ __ __ __ __ __ 5. |
  # | .4 __ __ __ __ __ __ __ __ 4. |
  # | .3 __ __ __ __ __ __ __ __ 3. |
  # | .2 Pa Pa Pa Pa Pa Pa Pa Pa 2. |
  # | .1 Pa Kn Bi Pa Ki Bi Kn Pa 1. |
  #      .A .B .C .D .E .F .G .H
  def to_s
    result = matrix.each_with_index.map do |row, y|
      center = row.map { |t| t.piece.to_sym }.join(" ")
      "| .#{y + 1} #{center} #{y + 1}. |"
    end.reverse.join("\n")

    [
      "\n     .A .B .C .D .E .F .G .H",
      result,
      "     .A .B .C .D .E .F .G .H"
    ].compact.join("\n")
  end

  def inspect
    "#<#{matrix}>"
  end
end

class Move
  def to_s; inspect; end

  def inspect
    "#<Move:#{start_tile.position}-#{destination_tile.position}>"
  end
end

class Moves::Abstract
  def to_s; inspect; end

  def inspect
    "#<#{self.class}:#{move.inspect}>"
  end
end

class Pieces::Null
  def self.to_sym
    '__'.to_sym
  end

  def to_s; inspect; end

  def inspect
    %(#<Pieces::Null>)
  end
end

class Pieces::Abstract
  def self.to_sym
    to_s['Pieces::'.length, 2].to_sym
  end

  def to_s; inspect; end

  def inspect
    %(#<#{self.class}:init-#{description}>)
  end

  def to_sym
    self.class.to_sym
  end
end

class Tile
  def to_s; inspect; end

  def inspect
    "#<Tile:#{position.to_s}:#{piece.to_sym}>"
  end
end

class Position
  def inspect
    "#<Position:#{to_s}>"
  end

  # to_s # Part of the logic
end
