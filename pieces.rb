require 'colorize'

class Piece

  attr_accessor :symbol, :color, :position, :board, :move_directions, :moved, :castled

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def to_s
    case color
    when :black
      symbol.to_s.black
    when :white
      symbol.to_s.red
    end
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def move_into_check?(destination)
    deep_board = board.deep_dup
    deep_board.move!(position, destination)
    deep_board.in_check?(color)
  end

  def moves
    rough_moves.select do |pos|
      pos.all? { |el| el < 8 && el >= 0 } &&
      (board[pos].nil? || board[pos].color != color)
    end
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

      while on_board?(next_pos) && board[next_pos].nil?
        legal_moves << next_pos
        last_position = next_pos
        next_pos = [last_position[0] + dir[0], last_position[1] + dir[1]]
      end
      legal_moves << next_pos
    end

    legal_moves
  end

end

class SteppingPiece < Piece

  def rough_moves
    new_moves = move_directions.map do |dir|
      [@position[0] + dir[0], @position[1] + dir[1]]
    end

    new_moves
  end
end

class King < SteppingPiece

  def initialize(color, position, board)
    super
    @symbol = "\u265A"
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
    @moved = false
    @castled = false
    @value = 1000000
  end

  def value
    return 1000005 if castled
    return 999995 if moved
    return 1000000
  end

  def may_castle_kingside?
    row = self.position[0]
    color = self.color
    return false if moved
    return false if board[([row, 7])].moved
    return false unless board[([row, 5])] == nil && board[([row, 6])] == nil
    return false if board.in_check?(color)
    return false if move_into_check?([row, 5])
    return false if move_into_check?([row, 6])
    return true
  end

  def may_castle_queenside?
    row = self.position[0]
    color = self.color
    return false if moved
    return false if board[([row, 0])].moved
    return false unless board[([row, 1])] == nil && board[([row, 2])] == nil && board[([row, 3])] == nil
    return false if board.in_check?(color)
    return false if move_into_check?([row, 3])
    return false if move_into_check?([row, 2])
    return true
  end

  def castle_kingside
    row = self.position[0]
    color = self.color
    king_start, king_fin = [row, 4], [row, 6]
    rook_start, rook_fin = [row, 7], [row, 5]
    board.move!(king_start, king_fin)
    board.move!(rook_start, rook_fin)
  end

  def castle_queenside
    row = self.position[0]
    color = self.color
    king_start, king_fin = [row, 4], [row, 2]
    rook_start, rook_fin = [row, 0], [row, 3]
    board.move!(king_start, king_fin)
    board.move!(rook_start, rook_fin)
  end

end

class Knight < SteppingPiece

  def initialize(color, position, board)
    super
    @symbol = "\u265E"
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
    @moved = false
    @value = 30
  end

  def value
    return 28 unless moved
    return 28 if position[0] == 0 || position[0] == 7
    return 28 if position[1] == 0 || position[1] == 7
    return 30
  end
end

class Rook < SlidingPiece

  def initialize(color, position, board)
    super
    @symbol = "\u265C"
    @move_directions = [
      [-1, 0],
      [0, 1],
      [1, 0],
      [0, -1]
    ]
    @moved = false
    @value = 50
  end

  def value
    return 52 unless moved
    return 50
  end
end

class Bishop < SlidingPiece

  def initialize(color, position, board)
    super
    @symbol = "\u265D"
    @move_directions = [
      [-1, -1],
      [1, 1],
      [1, -1],
      [-1, 1]
    ]
    @moved = false
    @value = 30
  end

  def value
    return 29 unless moved
    return 30
  end

end

class Queen < SlidingPiece

  def initialize(color, position, board)
    super
    @symbol = "\u265B"
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
    @moved = false
    @value = 90
  end

  def value
    return 93 unless moved
    return 90
  end

end

class Pawn < Piece
  attr_reader :step, :capture

  def rough_moves
    legal_moves = []
    legal_moves << pawn_steps if board[pawn_steps].nil?
    legal_moves << march unless march.nil?
    legal_moves.concat(pawn_captures)
    legal_moves
  end

  def pawn_steps
    [position[0] + step[0], position[1] + step[1]]
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
  def initialize(color, position, board)
    super
    @symbol = "\u265F"
    @step = [-1, 0]
    @capture = [[-1, 1], [-1, -1]]
    @moved = false
    @value = 10
  end

  def march
    if position[0] == 6 && board[pawn_steps].nil? && board[offset(position, [-2,0])].nil?
      return offset(position, [-2,0])
    end
  end

  def value
    return 12 if position == [6, 5]
    return 15 if position[0] == 2 || position[0] == 1
    return 10
  end

  def promote
    if position[0] == 0
      col = self.position[1]

      board.grid[0][col] = Queen.new(:white, [0, col], board)
    end
  end

end

class BlackPawn < Pawn

  def initialize(color, position, board)
    super
    @symbol = "\u265F"
    @step = [1, 0]
    @capture = [[1, 1], [1, -1]]
    @moved = false
    @value = 10
  end

  def march
    if position[0] == 1 && board[pawn_steps].nil? && board[offset(position, [2,0])].nil?
      return offset(position, [2,0])
    end
  end

  def value
    return 17 if position == [1, 5]
    return 15 if position[0] == 5 || position[0] == 6
    return 10
  end

  def promote
    if position[0] == 7
      col = self.position[1]

      board.grid[7][col] = Queen.new(:black, [7, col], board)
    end
  end

end
