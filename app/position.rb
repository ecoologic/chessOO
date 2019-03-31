# Wraps the info 'A1' to provides helper methods
# like coordinates [x, y], distances etc
# No dependencies
class Position
  # Math between two positions
  class Delta
    def initialize(position_a, position_b)
      @position_a, @position_b = position_a, position_b
    end

    def position
      Position.from_coordinates([delta_x, delta_y])
    end

    def all_between
      positions =
        if delta_x.zero? || delta_y.zero?
          all_along_axes
        else # TODO: ensure 45 degree
          all_along_diagonal
        end

      reject_first_and_last(positions) # Exclude start and destination
    end

    private

    attr_reader :position_a, :position_b

    def delta_x
      position_b.x - position_a.x
    end

    def delta_y
      position_b.y - position_a.y
    end

    def all_along_diagonal
      x_range.zip(y_range).map do |x, y|
        Position.from_coordinates([x, y])
      end
    end

    def all_along_axes
      if position_a.letter == position_b.letter
        y_range.map do |path_y|
          Position.from_coordinates([position_a.x, path_y])
        end
      else
        [Position.new('E1')] # TODO: Loop letters
      end
    end

    def x_range
      Range.new(*[position_a.x, position_b.x].sort)
    end

    def y_range
      Range.new(*[position_a.y, position_b.y].sort)
    end

    def reject_first_and_last(positions)
      positions[1..positions.length - 2]
    end
  end

  def self.from_coordinates(coordinate_couple)
    x, y = coordinate_couple
    letter_x = ('A'.bytes.first + x).chr
    number_y = y + 1

    new("#{letter_x}#{number_y}")
  end

  def initialize(value)
    @x = value.chars.first.upcase.bytes.first - 'A'.bytes.first
    @y = value.chars.last.to_i - 1 # Classic -1: index starting at 0
  end

  attr_reader :x, :y

  def ==(other_position)
    to_s == other_position.to_s
  end

  # 'B3' => [1, 2]
  def coordinates
    [x, y]
  end

  def letter
    ('A'.bytes.first + x).chr
  end

  def number
    y + 1
  end

  private

  attr_reader :value
end
