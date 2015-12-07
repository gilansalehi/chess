require 'colorize'

class Piece

  CARDINALS = {
    N: [-1, 0],
    NE: [-1, 1],
    E: [0, 1],
    SE: [1, 1],
    S: [1, 0],
    SW: [1, -1],
    W: [0, -1],
    NW: [-1, -1]
  }

  attr_accessor :symbol, :color, :position, :board, :my_moves

  def initialize(symbol, color, position = nil, board = nil)
    @symbol = symbol
    @color = color
    @position = position
    @board = board
  end

  def to_s
    case color
    when :black
      symbol.to_s.bold.black
    when :white
      symbol.to_s.bold.red
    end
  end

  def moves
    # arr1, comes from subclass
    # select method that allows only empty squares on the board or enemy pieces
    # array modified
    # hilight legal moves in rendering
    rough_moves.select do |pos| # filters out moves off board or onto friendly pieces
      pos.all? { |el| el < 8 && el >= 0 } &&
      (board[pos].nil? || board[pos].color != color)
    end
    # return final move array
  end

end

class SlidingPiece


end

class SteppingPiece < Piece

  def rough_moves
    my_moves.map! do |dir| # takes current positions and returns array of adj positions
      [@position[0] + dir[0], @position[1] + dir[1]]
    end
  end
end

class King < SteppingPiece

  def initialize(symbol, color, position = nil, board = nil)
    super
    @my_moves = [
      [-1, 0],
      [-1, 1],
      [0, 1],
      [1, 1],
      [1, 0],
      [1, -1],
      [0, -1],
      [-1, -1]
    ]
  end

  #old_code
  # @directions
  #
  #
  # directions = []
  #
  # CARDINALS.each do |_, delta|
  #   directions << delta
  # end

end

class Knight < SteppingPiece

  def initialize(symbol, color, position = nil, board = nil)
    super
    @my_moves = [
      [-2, 1],
      [-1, 2],
      [1, 2],
      [2, 1],
      [2, -1],
      [1, -2],
      [-1, -2],
      [-2, -1]
    ]
  end


end


class Rook < SlidingPiece

end
