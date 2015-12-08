require 'colorize'
require 'byebug'

class Piece

  attr_accessor :symbol, :color, :position, :board, :move_directions

  def initialize(symbol, color, position, board)
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

class SlidingPiece < Piece

  def on_board?(pos)
    pos.all? { |el| el < 8 && el >= 0 }
  end

  def rough_moves
    legal_moves = []

    @move_directions.each do | dir |
      last_position = position
      next_pos = [last_position[0] + dir[0], last_position[1] + dir[1]]
      # debugger
      while on_board?(next_pos) && board[next_pos].nil?  # write an on_board method
        legal_moves << next_pos
        last_position = next_pos
        next_pos = [last_position[0] + dir[0], last_position[1] + dir[1]]
      end
      legal_moves << next_pos  # this covers capture but might include illegal
      #moves---filter out in move method in Piece
    end

    legal_moves
  end

end

class SteppingPiece < Piece

  def rough_moves
    new_moves = move_directions.map do |dir| # takes current positions and returns array of adj positions
      [@position[0] + dir[0], @position[1] + dir[1]]
    end
    new_moves
  end
end

class King < SteppingPiece

  def initialize(symbol, color, position, board)
    super
    @move_directions = [
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

end

class Knight < SteppingPiece

  def initialize(symbol, color, position, board)
    super
    @move_directions = [
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

  def initialize(symbol, color, position, board)
    super
    @move_directions = [
      [-1, 0],
      [0, 1],
      [1, 0],
      [0, -1]
    ]
  end

end

class Bishop < SlidingPiece

  def initialize(symbol, color, position, board)
    super
    @move_directions = [
      [-1, -1],
      [1, 1],
      [1, -1],
      [-1, 1]
    ]
  end

end

class Queen < SlidingPiece

  def initialize(symbol, color, position, board)
    super
    @move_directions = [
      [-1, 0],
      [0, 1],
      [1, 0],
      [0, -1],
      [-1, -1],
      [1, 1],
      [1, -1],
      [-1, 1]
    ]
  end

end

class Pawn < Piece
  attr_reader :move, :capture

  def rough_moves
    legal_moves = []
    legal_moves << pawn_steps if board[pawn_steps].nil?
    legal_moves << march unless march.nil?
    legal_moves.concat(pawn_captures)
    legal_moves
  end

  def pawn_steps
    [position[0] + move[0], position[1] + move[1]]
  end

  def pawn_captures
    candidate_moves = []
    capture.each  do |dir|
      new_pos = [position[0] + dir[0], position[1] + dir[1]]
      candidate_moves << new_pos unless board[new_pos].nil?
    end
    candidate_moves
  end

  def offset(position, delta)
    [position[0] + delta[0], position[1] + delta[1]]
  end

end

class WhitePawn < Pawn
  def initialize(symbol, color, position, board)
    super
    @move = [-1, 0]
    #special method called "march", check if pawn is on row 1, if so
    @capture = [[-1, 1], [-1, -1]]
    # promotion !!!! bonus
  end

  def march
    if position[0] == 6 && board[pawn_steps].nil? && board[offset(position, [-2,0])].nil?
      return offset(position, [-2,0])
    end
  end

end

class BlackPawn < Pawn

  def initialize(symbol, color, position, board)
    super
    @move = [1, 0]
    #special method called "march", check if pawn is on row 1, if so
    @capture = [[1, 1], [1, -1]]
    # promotion !!!! bonus
  end

  def march
    if position[0] == 1 && board[pawn_steps].nil? && board[offset(position, [2,0])].nil?
      return offset(position, [2,0])
    end
  end

end
