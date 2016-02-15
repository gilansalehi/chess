require 'byebug'

class ComputerPlayer

  attr_accessor :board

  def intialize()
    @color = color
    @board = board
    @eval = 0 #score for white and for black
  end

  def pick_random_move(board)
    my_pieces = []

    board.grid.flatten.compact.each do |square|
      my_pieces << square if square.color == :black
    end

    piece = my_pieces.shuffle.first

    until piece.valid_moves.length > 0
      piece = my_pieces.shuffle.first
    end

    start = piece.position
    fin = piece.valid_moves.shuffle.first
    return [start, fin]
  end

  def play_move(board)
    puts("thinking...")
    board.children = []
    calculate_move(board, 2)
    # arr = pick_random_move(board) # Goal: replace this line with a more complex algorithm
    arr = pick_best_move(board)
    debugger
    board.move!(arr[0], arr[1])
    board.switch_player
  end

  def pick_best_move(board)
    vals = board.children.map { |child| child.eval }
    best_pos = board.children.select{ |child| child.eval == vals.min } # min because negative scores are good for black
    debugger
    return best_pos[0].previous_move
  end

  def evaluate(board)

    if board.children.length > 0
      vals = board.children.map { |child| child.eval }
      if board.current_player == "white"
        board.eval = vals.max # plus scores indicate good board states for white
      else
        board.eval = vals.min # minus indicates good board states for black, aka the computer
      end
    else
      board.eval = blind_eval(board)
    end
  end

  def blind_eval(board)
    # this method will assign a score to a board state without considering future moves
    white_score, black_score = 0, 0

    board.grid.flatten.compact.each do |square| #compact removes nil values
      square.color == :white ? white_score += square.value : black_score += square.value
    end

    return white_score - black_score
  end

  def calculate_move(board, depth)
    return blind_eval(board) if depth == 0 # base case; we've searched to the intended depth

    board.legal_moves.each do |move|
      # make the move
      deep_board = board.deep_dup
      position, destination = move # parallel assignment

      deep_board.move!(position, destination)
      deep_board.previous_move = [position, destination]
      deep_board.switch_player
      board.children << deep_board
      calculate_move(deep_board, depth - 1) if blind_eval(deep_board) <= blind_eval(board) + 5 # reductive step

      evaluate(deep_board)
      puts(move.to_s + " " + deep_board.eval.to_s + ", " + depth.to_s)
    end

  end

end
