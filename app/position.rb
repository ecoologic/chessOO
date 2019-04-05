# No dependencies
#
# Wraps the value 'A1' to provide helper methods
# like coordinates [x, y], comparisons etc
class Position
  # Properties between two positions
  class Delta
    def initialize(position_a, position_b)
      @position_a, @position_b = position_a, position_b
    end

    def all_between
      positions =
        if x.zero? || y.zero?
          all_along_axis # all_along_letter/number
        else # TODO: ensure 45 degree
          # TODO: all_along_diagonal(y_range.zip(x_range.reverse)) x2
          all_along_diagonal
        end

      reject_first_and_last(positions) # Start and destination
    end

    def l_shape?
      [x.abs, y.abs].sort == [1, 2]
    end

    # TODO: one_forward?(color) # forward_y_by_color = { white: 1, black: -1 }
    def one_forward?
      [x, y.abs] == [0, 1]
    end

    def one_up_diagonal?
      [x.abs, y.abs] == [1, 1]
    end

    def one_step?
      [0, x.abs, y.abs].minmax == [0, 1]
    end

    def diagonal?
      x.abs == y.abs
    end

    def one_axis?
      x.zero? || y.zero?
    end

    def x
      position_b.x - position_a.x
    end

    def y
      position_b.y - position_a.y
    end

    private

    attr_reader :position_a, :position_b

    def all_along_diagonal
      x_range.zip(y_range).map do |x, y|
        Position.from_coordinates([x, y])
      end
    end

    def all_along_axis
      if position_a.letter == position_b.letter # TODO: use diagonal => :x, :y, nil
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

  ############################################################################

  def self.from_coordinates(coordinates)
    x, y = coordinates
    letter_x = ('A'.bytes.first + x).chr
    number_y = y + 1

    new("#{letter_x}#{number_y}")
  end

  def initialize(value)
    position_value = value.to_s
    @x = position_value.chars.first.upcase.bytes.first - 'A'.bytes.first
    @y = position_value.chars.last.to_i - 1 # Classic -1: index starting at 0
  end

  attr_reader :x, :y

  def to_s
    "#{letter}#{number}"
  end

  def <=(other_position)
    x <= other_position.x && y <= other_position.y
  end

  def ==(other_position)
    coordinates == other_position.coordinates
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
